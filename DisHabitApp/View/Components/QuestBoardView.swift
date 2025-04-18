import Foundation
import SwiftUI
import SwiftData

struct QuestBoardView: View {
    @Binding var selectedDate: Date
    @Binding var showTabBar: Bool
    @Binding var path: [QuestBoardNavigation]
    
    @Environment(\.modelContext) private var modelContext
    @StateObject var vm: QuestBoardViewModel = QuestBoardViewModel()
    
    @Query var standbyQuests: [Quest]
    
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
    
    func fetchQuestBoard() -> DailyQuestBoard? {
        do {
            let fetchDescriptor = FetchDescriptor<DailyQuestBoard>()
            let boards = try modelContext.fetch(fetchDescriptor)
            let date = self.selectedDate
            return boards.first(where: { $0.date.isSameDayAs(date) })
        }
        catch {
            return nil
        }
    }
    
    var displayedQuestSlotManagers: [QuestSlotManager] {
        if let board = fetchQuestBoard() {
            return board.questSlots.map { QuestSlotManager(questSlot: $0, questBoardDate: selectedDate, tense: tense) }
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

        // activeQuestsの中から、selectedDateの曜日を持つQuestからQuestSlotを作成
        let date = self.selectedDate
        let questSlots = standbyQuests.filter { $0.activatedDayOfWeeks[date.weekday()] == true }.map { QuestSlot(quest: $0) }
        let questSlotManagers = questSlots.map { QuestSlotManager(questSlot: $0, questBoardDate: selectedDate, tense: tense) }

        let newBoard = DailyQuestBoard(date: date, questSlots: questSlots)

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
                    ForEach(displayedQuestSlotManagers) { questSlotManager in
                        if let acceptedQuest = questSlotManager.questSlot.acceptedQuest {
                            if acceptedQuest.isCompletionReported {
                                TicketCard(vm: vm, acceptedQuest: acceptedQuest)
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            showTabBar = false
                                        }
                                        path.append(.questDetails(questSlot: questSlotManager.questSlot))
                                    }
                            } else {
                                AcceptedQuestCard(vm: vm, acceptedQuest: acceptedQuest)
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            showTabBar = false
                                        }
                                        path.append(.questDetails(questSlot: questSlotManager.questSlot))
                                    }
                            }
                        } else {
                            StandbyQuestCard(vm: vm, quest: questSlotManager.questSlot.quest, questSlotId: questSlotManager.questSlot.id)
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        showTabBar = false
                                    }
                                    path.append(.questDetails(questSlot: questSlotManager.questSlot))
                                }
                        }
                    }
                    #if DEBUG
                    Button {
                        _Concurrency.Task {
                            await vm.debug_ResetAcceptedQuests()
                        }
                    } label: {
                        Text("DEBUG:受注リセット")
                    }
                    Button {
                        _Concurrency.Task {
                            await vm.debug_ReloadTodayQuestBoard()
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

