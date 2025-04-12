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

struct AcceptedTicket: View {
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("御上先生")
                    .font(.title)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110)
            .border(.red)
            HStack(spacing: 0) {
                VStack(spacing: 5) {
                    Text("期日")
                        .font(.callout)
                    Text("12/31")
                        .font(.title3)
                }
            }
            .frame(width: 100, height: 110)
            .border(.red)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background(Color.gray, in: RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal, 25)
    }
}

#Preview {
    AcceptedTicket()
}
