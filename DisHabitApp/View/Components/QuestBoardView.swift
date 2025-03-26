import Foundation
import SwiftUI

struct QuestBoardView: View {
    @ObservedObject var vm: QuestBoardViewModel
    let namespace: Namespace.ID
   
    init (vm: QuestBoardViewModel, namespace: Namespace.ID) {
        self.vm = vm
        self.namespace = namespace
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
                                NavigationLink(destination: AcceptedQuestDetailsPage()) {
                                    AcceptedQuestCard(vm: vm, acceptedQuest: acceptedQuest, namespace: namespace)
                                }
                                .buttonStyle(.plain)
                            }
                        } else {
                            NavigationLink(destination: AcceptedQuestDetailsPage()) {
                                StandbyQuestCard(vm: vm, quest: questSlot.quest, questSlotId: questSlot.id)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.1))
    }
}

#Preview {
    HomePage(vm: QuestBoardViewModel(appDataService: AppDataService()))
}
