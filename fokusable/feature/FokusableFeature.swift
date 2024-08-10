import ComposableArchitecture
import Foundation
import Logging

@Reducer
struct FokusableFeature {
  
  enum NoteState: Equatable {
    case empty
    case list(items: IdentifiedArrayOf<NoteItem>)
    case error
  }
  
  @ObservableState
  struct State: Equatable {
    var dayState: DayState = .empty
    var noteState: NoteState = .empty
  }
  
  enum Action {
    // Viewが表示された時
    case onEnter
    // 日付データの取得が完了した時
    case onFetchedDays(IdentifiedArrayOf<DayItem>)
    // 日付データの取得に失敗した時
    case onFailedFetchingDays(Error)
    // 日付が選択された時
    case onSelectedDay(DayItem)
    // ノートの取得が完了した時
    case onFetchedNote(IdentifiedArrayOf<NoteItem>)
    // ノートの取得に失敗した時
    case onFailedFetchingNote(Error)
    // ノートが編集された時
    case onEditNote(UUID)
    // ノートが完了された時
    case onCheckNote(UUID)
    // ノートが保存された時
    case onSaveNote(UUID, String)
  }
  
  @Dependency(\.dayFetchingService) var dayFetchingService: DayFetchingService
  
  @Dependency(\.noteFetchingService) var noteFetchingService: NoteFetchingService
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case .onEnter:
        // 画面が表示された時、日付を取得する。
        // 日付の取得に成功した場合はonFetchedDaysを、
        // 日付の取得に失敗した場合はonFailedFetchingDaysを呼び出す。
        return .run { send in
          switch await dayFetchingService.fetchAll() {
          case .success(let days):
            await send(.onFetchedDays(days))
          case .failure(let error):
            await send(.onFailedFetchingDays(error))
          }
        }
        
      case .onFetchedDays(let days):
        // 日付データの取得に成功した日付をViewに反映し、さらに当日の日付を取得する。
        // 当日の日付の取得に成功した場合はonSelectedDayを呼び出す。
        // 当日の日付の取得に失敗した場合はonFailedFetchingNoteを呼び出す（ノートの取得に失敗した扱いにする）。
        state.dayState = .list(items: days)
        return .run { send in
          switch await dayFetchingService.fetchToday() {
          case .success(let today):
            await send(.onSelectedDay(today))
          case .failure(let error):
            await send(.onFailedFetchingNote(error))
          }
        }
        
      case .onFailedFetchingDays(let error):
        // 日付のエラー状態をViewに反映する。
        logger.error("fetching days failed with \(error)")
        state.dayState = .error
        return .none
        
      case .onSelectedDay(let day):
        // 選択された日付のノートを取得する。
        // 当日のノートの取得に成功した場合、空のノートを作成して編集状態とした上、
        // onFetchedNoteを呼び出す。
        // 当日のノートの取得に失敗した場合、onFailedFetchingNoteを呼び出す。
        state.noteState = .empty
        return .run { send in
          let fetchedNotes = await noteFetchingService.fetchById(day.id)
          logger.info("fetched notes = \(fetchedNotes)")
          switch fetchedNotes {
          case .success(var notes):
            // 空のノートを作成し、そのノートを編集状態にする
            let emptyNote = NoteItem(id: UUID(), isDone: false, text: "", isEdit: true)
            notes.append(emptyNote)
            await send(.onFetchedNote(notes))
          case .failure(let error):
            await send(.onFailedFetchingNote(error))
          }
        }
        
      case .onFetchedNote(let notes):
        // ノートをViewに反映する。
        state.noteState = .list(items: notes)
        return .none
        
      case .onFailedFetchingNote(let error):
        // ノートのエラー状態をViewに反映する。
        logger.error("fetching notes failed with \(error)")
        state.noteState = .error
        return .none
        
      case .onEditNote(let id):
        // 対象のノートを編集状態とした上、それ以外のノートの編集状態を解除する。
        switch state.noteState {
        case .list(let noteItems):
          state.noteState = .list(
            items: IdentifiedArrayOf(
              uniqueElements: noteItems
                .map { noteItem in
                  // 編集されたノート以外は処理しないのでスキップ
                  if noteItem.id != id {
                    if noteItem.isEdit {
                      // 対象のノート以外の編集モードを解除する
                      return NoteItem(id: noteItem.id, isDone: noteItem.isDone, text: noteItem.text, isEdit: false)
                    } else {
                      return noteItem
                    }
                  }
                  
                  return NoteItem(id: noteItem.id, isDone: noteItem.isDone, text: noteItem.text, isEdit: true)
                }
            )
          )
        default:
          logger.info("illegal state, note should be a list")
        }
        return .none
        
      case .onCheckNote(let id):
        // ノートのチェックボタンが押下された時、チェック状態を反転する。
        switch state.noteState {
        case .list(let noteItems):
          state.noteState = .list(
            items: IdentifiedArrayOf(
              uniqueElements: noteItems
                .map { noteItem in
                  // 編集されたノート以外は処理しないのでスキップ
                  if noteItem.id != id {
                    return noteItem
                  }
                  
                  let isDone = noteItem.isDone
                  return NoteItem(id: noteItem.id, isDone: !isDone, text: noteItem.text, isEdit: false)
                }
            )
          )
        default:
          logger.info("illegal state, note should be a list")
        }
        return .none
        
      case .onSaveNote(let id, let text):
        // ノートが保存された時、ノートのテキスト画が空でなければ新たな空のノートを作成する。
        // 保存されたノートをViewに反映する。
        switch state.noteState {
        case .list(var noteItems):
          if text != "" {
            // ノートが保存された時、新たに空のノートを作成する。
            noteItems.append(
              NoteItem(id: UUID(), isDone: false, text: "", isEdit: true)
            )
          }
          
          state.noteState = .list(
            items: IdentifiedArrayOf(
              uniqueElements: noteItems
                .map { noteItem in
                  // 編集されたノート以外は処理しないのでスキップ
                  if noteItem.id != id {
                    return noteItem
                  }
                  
                  return NoteItem(id: noteItem.id, isDone: noteItem.isDone, text: text, isEdit: false)
                }
            )
          )
        default:
          logger.info("illegal state, note should be a list")
        }
        return .none
      }
    }
  }
  
  private let logger = Logger(label: "FokusableFeature")
}
