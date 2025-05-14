import Foundation
import SwiftUI

struct QuestSlotContainer: View {
    var manager: QuestSlotManager
    @Binding var showTabBar: Bool
    
    var body: some View {
            VStack {
                if let acceptedQuest = manager.questSlot.acceptedQuest {
                    if acceptedQuest.isCompletionReported {
                        TicketCard(manager: manager)
                    }
                    else {
                        AcceptedQuestCard(manager: manager)
                    }
                    
                } else {
                    StandbyQuestCard(manager: manager, showTabBar: $showTabBar, quest: manager.questSlot.quest)
                }
#if DEBUG
//                Button (action: {
//                    manager.archiveQuest()
//                }, label: {
//                    Text("削除")
//                })
#endif
            }
            .onTapGesture {
                showTabBar = false
                Router.shared.path.append(manager)
            }
    }
}

