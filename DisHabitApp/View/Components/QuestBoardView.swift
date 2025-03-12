import Foundation
import SwiftUI

struct QuestBoardView: View {
    @ObservedObject var vm: QuestBoardViewModel
   
    init (vm: QuestBoardViewModel) {
       self.vm = vm
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
                    VStack (spacing: 0) {
                        if let acceptedQuest = questSlot.acceptedQuest {
                            if acceptedQuest.isCompletionReported {
                                // チケットを表示
                                // 使用済みかどうかは子コンポーネント上で分岐させる
                                TicketCard(vm: vm, acceptedQuest: acceptedQuest)
                            } else {
                                // 進行中クエスト
                                AcceptedQuestCard(vm: vm, acceptedQuest: acceptedQuest)
                            }
                        } else {
                            // 未受注クエスト
                            StandbyQuestCard(vm: vm, quest: questSlot.quest, questSlotId: questSlot.id)
                        }
                    }

                }.background(Color.gray.opacity(0.1))
            }
        }
    }
}

#Preview {
    QuestBoardView(vm: QuestBoardViewModel(appDataService: AppDataService()))
}
