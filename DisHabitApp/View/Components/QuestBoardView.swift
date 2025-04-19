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
        } else if self.selectedDate < today {
            return .past
        } else {
            return .future
        }
    }
    
    @Query var standbyQuests: [Quest]
    @Query var dailyQuestBoards: [DailyQuestBoard]
    @Query var objectives: [Objective] //temp
    
    
    var displayedQuestSlots: [QuestSlotManager] {
        //temp
//        standbyQuests[0].tasks.append(StandbyTask(text: "腹筋10回", objective: objectives[0]))
//        standbyQuests[0].tasks.append(StandbyTask(text: "腕立て2億回", objective: objectives[0]))
//        standbyQuests[1].tasks.append(StandbyTask(text: "英単語5個暗記", objective: objectives[1]))
//        standbyQuests[1].tasks.append(StandbyTask(text: "基本情報2ページ", objective: objectives[1]))
        //temp
        
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
    
//    func fetchQuestBoard() -> DailyQuestBoard? {
//        do {
//            let fetchDescriptor = FetchDescriptor<DailyQuestBoard>()
//            let boards = try modelContext.fetch(fetchDescriptor)
//            let date = self.selectedDate
//            return boards.first(where: { $0.date.isSameDayAs(date) })
//        }
//        catch {
//            return nil
//        }
//    }
    
//    @State var questSlotManagers: [QuestSlotManager] = []
    
//    func displayedQuestSlotManagers() -> [QuestSlotManager] {
//        if let board = fetchQuestBoard() {
//            print("AAA if let")
//            let managers = board.questSlots.map {
//                QuestSlotManager(
//                    modelContext: modelContext,
//                    board: board,
//                    questSlot: $0,
//                    tense: tense
//                )}
//            return managers
//        } else {
//            print("if let else")
//            switch tense {
//            case .today, .future:
//                let questSlotManagers = createQuestBoard()
//                return questSlotManagers
//            case .past:
//                return []
//            }
//        }
//    }
    
    private func createQuestBoard() -> [QuestSlotManager] {
        if tense == .past {
            fatalError("You do not create past quest board with createQuestBoard()")
        }
        
        print("Creating new DailyQuestBoard")

        // activeQuestsの中から、selectedDateの曜日を持つQuestからQuestSlotを作成
        let date = self.selectedDate
        let questSlots = standbyQuests.filter { $0.activatedDayOfWeeks[date.weekday()] == true }.map { QuestSlot(quest: $0) }


        let newBoard = DailyQuestBoard(date: date, questSlots: questSlots)
        
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
//                    ForEach(displayedQuestSlotManagers) { q in
//                        
//                    }
                    ForEach(displayedQuestSlots.indices, id: \.self) { index in
                        QuestSlotContainer(manager: displayedQuestSlots[index])
//                        NavigationStack {
                        
//                            if let acceptedQuest = manager.questSlot.acceptedQuest {
//                                if acceptedQuest.isCompletionReported {
//                                    TicketCard(manager: manager, acceptedQuest: acceptedQuest)
//                                        .onTapGesture {
//                                            withAnimation(.easeOut(duration: 0.3)) {
//                                                showTabBar = false
//                                            }
//                                            detailsNavigationPath.append(manager)
//    //                                        path.append(.questDetails(questSlot: questSlotManager.questSlot))
//                                        }
//                                }
//                                else {
//                                    AcceptedQuestCard(manager: manager, acceptedQuest: acceptedQuest)
//                                        .onTapGesture {
//                                            withAnimation(.easeOut(duration: 0.3)) {
//                                                showTabBar = false
//                                            }
//                                            detailsNavigationPath.append(manager)
//    //                                        path.append(.questDetails(questSlot: questSlotManager.questSlot))
//                                        }
//                                }
//                                
//                            } else {
//                                StandbyQuestCard(manager: manager, quest: manager.questSlot.quest)
//                                    .onTapGesture {
//                                        withAnimation(.easeOut(duration: 0.3)) {
//                                            showTabBar = false
//                                        }
//                                        detailsNavigationPath.append(manager)
//    //                                    path.append(.questDetails(questSlot: questSlotManager.questSlot))
//                                    }
//                            }
//                        }
//                        .navigationDestination(for: QuestSlotManager.self) { manager in
//                            QuestDetailsPage(manager: manager, path: $detailsNavigationPath)
//                        }

                    }
                    #if DEBUG
                    Button {
                        standbyQuests[0].tasks.append(StandbyTask(text: "腹筋10回", objective: objectives[0]))
                        standbyQuests[0].tasks.append(StandbyTask(text: "腕立て2億回", objective: objectives[0]))
                        standbyQuests[1].tasks.append(StandbyTask(text: "英単語5個暗記", objective: objectives[1]))
                        standbyQuests[1].tasks.append(StandbyTask(text: "基本情報2ページ", objective: objectives[1]))
                    } label: {
                        Text("充填")
                    }
                    Button {
                        _Concurrency.Task {
//                            await vm.debug_ResetAcceptedQuests()
                        }
                    } label: {
                        Text("DEBUG:受注リセット")
                    }
                    Button {
                        _Concurrency.Task {
//                            await vm.debug_ReloadTodayQuestBoard()
                        }
                    } label: {
                        Text("DEBUG:todayQuestBoard再作成")
                    }

                    #endif
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}

