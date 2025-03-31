import Foundation
import SwiftUI

struct QuestBoardView: View {
    @ObservedObject var vm: QuestBoardViewModel
    @Binding var showTabBar: Bool
    @Binding var path: [QuestBoardNavigation]
   
    init (
        vm: QuestBoardViewModel,
        showTabBar: Binding<Bool>,
        path: Binding<[QuestBoardNavigation]>
    ) {
        self.vm = vm
        self._showTabBar = showTabBar
        self._path = path
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
                .padding(.leading, 30)
                .padding(.top, 18)
                .padding(.bottom, 18)
            // クエストリスト
            ScrollView(.vertical) {
                Spacer() // 要検討
                VStack(spacing: 18) {
                    ForEach(vm.dailyQuestBoard.questSlots) { questSlot in
                        if let acceptedQuest = questSlot.acceptedQuest {
                            if acceptedQuest.isCompletionReported {
                                TicketCard(vm: vm, acceptedQuest: acceptedQuest)
                            } else {
                                AcceptedQuestCard(vm: vm, acceptedQuest: acceptedQuest)
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            showTabBar = false
                                        }
                                        path.append(.acceptedQuestDetails)
                                    }
                            }
                        } else {
                            StandbyQuestCard(vm: vm, quest: questSlot.quest, questSlotId: questSlot.id)
                                .onTapGesture {
                                    showTabBar = false
                                    path.append(.acceptedQuestDetails)
                                }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

