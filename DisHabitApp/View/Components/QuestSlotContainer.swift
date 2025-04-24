import Foundation
import SwiftUI

struct QuestSlotContainer: View {
    var manager: QuestSlotManager
    
    var body: some View {
            VStack {
                
                if let acceptedQuest = manager.questSlot.acceptedQuest {
                    if acceptedQuest.isCompletionReported {
                        //                    TicketCard(manager: manager, acceptedQuest: acceptedQuest)
                        //                        .onTapGesture {
                        //                            withAnimation(.easeOut(duration: 0.3)) {
                        ////                                showTabBar = false
                        //                            }
                        //                            detailsNavigationPath.append(manager)
                        //    //                                        path.append(.questDetails(questSlot: questSlotManager.questSlot))
                        //                        }
                    }
                    else {
                        AcceptedQuestCard(manager: manager)
                    }
                    
                } else {
                    StandbyQuestCard(manager: manager, quest: manager.questSlot.quest)
                }
            }
            .onTapGesture {
                print("QSC onTapGesture")
//                showTabBar = false
                Router.shared.detailsNavigationPath.append(manager)
            }
    }
}

