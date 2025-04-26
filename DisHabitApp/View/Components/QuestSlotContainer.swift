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
                    StandbyQuestCard(manager: manager, quest: manager.questSlot.quest)
                }
            }
            .onTapGesture {
                showTabBar = false
                Router.shared.path.append(manager)
            }
    }
}

