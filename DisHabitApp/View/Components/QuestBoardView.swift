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
        ScrollView(.vertical) {
            VStack(spacing: 18) {
                ForEach(vm.dailyQuestBoard.questSlots) { questSlot in
                    VStack(spacing: 0) {
                        if let acceptedQuest = questSlot.acceptedQuest {
                            if acceptedQuest.isCompletionReported {
                                // チケットを表示（変更なし）
                                TicketCard(vm: vm, acceptedQuest: acceptedQuest)
                            } else {
                                // パターン１: AcceptedQuestCardにNavigationLinkを移動
                                NavigationLink(destination: AcceptedQuestDetailsPage()) {
                                    AcceptedQuestCard(vm: vm, acceptedQuest: acceptedQuest, namespace: namespace)
                                }
                                .buttonStyle(.plain) // デフォルトの青リンク色を消す
                            }
                        } else {
                            // パターン２: StandbyQuestCardにNavigationLinkを移動（適切な遷移先を設定）
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
