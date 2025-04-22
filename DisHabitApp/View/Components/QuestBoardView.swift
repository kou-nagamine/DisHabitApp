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
    @Query var tasks: [StandbyTask] //temp!!
    @Query var qs: [QuestSlot] //temp!!
    
    
    
    var displayedQuestSlots: [QuestSlotManager] {
        if let board = dailyQuestBoards.first(where: { $0.date.isSameDayAs(self.selectedDate)}) {
            let managers = board.questSlots.map {
                QuestSlotManager(
                    modelContext: modelContext,
                    board: board,
                    questSlot: $0,
                    tense: tense
                )}
            return managers
        } else {
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
                        let boards = dailyQuestBoards /*.filter { $0.date.isSameDayAs(self.selectedDate)}*/
                        print("Found \(boards.count) boards")
                        print("QS: \(qs.count)")
                        for board in boards {
                            print("Removing board")
                            modelContext.delete(board)
                        }
                        for q in qs {
                            print("Removing QuestSlot")
                            modelContext.delete(q)
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
                            try modelContext.delete(model: DailyQuestBoard.self)
//                            let a = tasks
//                            let b = objectives
//                            let c = standbyQuests
                            
//                            let objective1 = Objective(id: UUID(), text: "健康的な生活を送る")
//                            let objective2 = Objective(id: UUID(), text: "勉強習慣を身につける")
//                            let objective3 = Objective(id: UUID(), text: "運動を習慣化する")
//                    
//                            let task1 = StandbyTask(id: UUID(), text: "朝7時に起床する", objective: objective1)
//                            let task2 = StandbyTask(id: UUID(), text: "朝食を食べる", objective: objective1)
//                            let task3 = StandbyTask(id: UUID(), text: "1時間勉強する", objective: objective2)
//                            let task4 = StandbyTask(id: UUID(), text: "30分ジョギングする", objective: objective3)
//                            let task5 = StandbyTask(id: UUID(), text: "ストレッチをする", objective: objective3)
//                    
//                            let reward1 = Reward(id: UUID(), text: "好きなお菓子を1つ買う")
//                            let reward2 = Reward(id: UUID(), text: "映画を見る")
//                    
//                            let quest1 = Quest(id: UUID(), activatedDayOfWeeks: [1: true, 2: true, 3: true, 4: true, 5: true, 6: true, 7: true], reward: reward1, tasks: [task1, task2, task5])
//                            let quest2 = Quest(id: UUID(), activatedDayOfWeeks: [1: true, 2: true, 3: true, 4: true, 5: true, 6: true, 7: true], reward: reward2, tasks: [task4, task5])
//                            
//                        
//                            modelContext.insert(objective1)
//                            modelContext.insert(objective2)
//                            modelContext.insert(objective3)
//                            modelContext.insert(task1)
//                            modelContext.insert(task2)
//                            modelContext.insert(task3)
//                            modelContext.insert(task4)
//                            modelContext.insert(task5)
//                            modelContext.insert(reward1)
//                            modelContext.insert(reward2)
//                            modelContext.insert(quest1)
//                            modelContext.insert(quest2)
//                            
//                            try modelContext.save()
                            
                            print("Deleted board & qs table")
                        } catch {
                            print("Failed to clear board & qs table: \(error)")
                        }
                    } label: {
                        Text("Board/QSテーブルをリセット")
                    }
#endif
//                    ForEach(displayedQuestSlots.indices, id: \.self) { index in
//                        QuestSlotContainer(manager: displayedQuestSlots[index])
//
//                    }

                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}

