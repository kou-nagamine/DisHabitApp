import Foundation
import SwiftUI
import SwiftData

struct QuestBoardView: View {
    @Binding var selectedDate: Date
    @Binding var showTabBar: Bool
    @Binding var path: [QuestBoardNavigation]
    
    @State private var detailsNavigationPath = NavigationPath()
    
    @Environment(\.modelContext) private var modelContext
//    @StateObject var vm: QuestBoardViewModel = QuestBoardViewModel()
    
    
    var tense: QuestBoardTense {
        let today = Date()
        if self.selectedDate.isSameDayAs(today) {
            return .today
        } else if self.selectedDate < today { // isSameDayAsに引っかからなかったモノのみここに到達するので、小なり現在時刻でOK
            return .past
        } else {
            return .future
        }
    }
    
    @Query var standbyQuests: [Quest]
    @Query var dailyQuestBoards: [DailyQuestBoard]
    @Query var objectives: [Objective] //temp
    
    
    
    var displayedQuestSlots: [QuestSlotManager] {
        if let board = dailyQuestBoards.first(where: { $0.date.isSameDayAs(self.selectedDate)}) {
            print("if let")
            let managers = board.questSlots.map {
                QuestSlotManager(
                    modelContext: modelContext,
                    board: board,
                    questSlot: $0,
                    tense: tense
                )}
            return managers
        } else {
            print("if let else")
            switch tense {
            case .today, .future:
                let questSlotManagers = createQuestBoard()
                return questSlotManagers
            case .past:
                return []
            }
        }
    }
    
    private func createQuestBoard() -> [QuestSlotManager] {
        if tense == .past {
            fatalError("You do not create past quest board with createQuestBoard()")
        }
        
        print("Creating new DailyQuestBoard")

        // activeQuestsの中から、selectedDateの曜日を持つQuestからQuestSlotを作成
        let date = self.selectedDate
        
        let newBoard = DailyQuestBoard(date: date, questSlots: [])
        let questSlots = standbyQuests.filter { $0.activatedDayOfWeeks[date.weekday()] == true }.map { QuestSlot(board: newBoard, quest: $0) }
        newBoard.questSlots = questSlots

        
        let questSlotManagers = questSlots.map { QuestSlotManager(
            modelContext: modelContext, board: newBoard, questSlot: $0, tense: tense) }

        // 未来の場合はSwiftDataに保存しない
        if tense == .today {
            modelContext.insert(newBoard)
        }
        
        return questSlotManagers
        
    }
   
    var screenWidth: CGFloat {
       guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
             let window = windowScene.windows.first else {
           return 0
       }
       return window.screen.bounds.width
    }
   
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // タイトル
            Text("楽しいこと習慣")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 18)
                .padding(.leading, 20)
                .padding(.bottom, 18)
            // クエストリスト
            ScrollView(.vertical) {
                Spacer() // 要検討
                VStack(spacing: 18) {
#if DEBUG
                    Button {
                        let boards = dailyQuestBoards.filter { $0.date.isSameDayAs(self.selectedDate)}
                        print("Found \(boards.count) boards")
                        for board in boards {
                            print("Removing board")
                            modelContext.delete(board)
                        }
                        
                    } label: {
                        Text("Board削除")
                    }
                    Button {
                        print(dailyQuestBoards.count)
                        for board in dailyQuestBoards {
                            print(board.date)
                        }
                        _Concurrency.Task {
//                            await vm.debug_ResetAcceptedQuests()
                        }
                    } label: {
                        Text("DEBUG:受注リセット")
                    }
                    Button {
                        do {
                            try modelContext.delete(model: DailyQuestBoard.self)
                            try modelContext.delete(model: QuestSlot.self)
                        } catch {
                            print("Failed to clear all Country and City data.")
                        }
                    } label: {
                        Text("DEBUG:todayQuestBoard再作成")
                    }
#endif
                    ForEach(displayedQuestSlots.indices, id: \.self) { index in
                        QuestSlotContainer(manager: displayedQuestSlots[index])

                    }

                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}

