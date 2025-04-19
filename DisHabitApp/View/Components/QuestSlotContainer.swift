//
//  QuestSlotContainer.swift
//  DisHabitApp
//
//  Created by nafell on 2025/04/19.
//

import Foundation
import SwiftUI

struct QuestSlotContainer: View {
    var manager: QuestSlotManager
    
    @State private var detailsNavigationPath = NavigationPath()
    
    var body: some View {
//        NavigationStack {
            VStack{
                
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
//                        Button(action: {
//                            manager.questSlot.acceptedQuest = nil
//                        }, label: {Text("諦める")})
                        AcceptedQuestCard(manager: manager)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: 0.3)) {
    //                                showTabBar = false
                                }
                                detailsNavigationPath.append(manager)
        //                                        path.append(.questDetails(questSlot: questSlotManager.questSlot))
                            }
                    }
                    
                } else {
                    StandbyQuestCard(manager: manager, quest: manager.questSlot.quest)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)) {
                                //                            showTabBar = false
                            }
                            detailsNavigationPath.append(manager)
                            //                                    path.append(.questDetails(questSlot: questSlotManager.questSlot))
                        }
                }
            }
//            .navigationDestination(for: QuestSlotManager.self) { manager in
//                QuestDetailsPage(manager: manager, path: $detailsNavigationPath)
//            }
//        }

    }
//        .navigationDestination(for: QuestSlotManager.self) { manager in
//            QuestDetailsPage(manager: manager, path: $detailsNavigationPath)
//        }
}

