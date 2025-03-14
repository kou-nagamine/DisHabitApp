//
//  TicketCard.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/03/12.
//

import Foundation
import SwiftUI

struct TicketCard: View {
    @ObservedObject var vm: QuestBoardViewModel
    var acceptedQuest: AcceptedQuest
    
    var body: some View {
        if acceptedQuest.reward.isRedeemed {
            Text("使用済みチケット")
        } else {
            Button(action: {
                //redeem
            }, label: {
                Text("チケットを使う")
            })
        }
    }
}

