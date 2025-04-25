//
//  TicketCard.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/03/12.
//

import Foundation
import SwiftUI

struct TicketCard: View {
//    @ObservedObject var vm: QuestBoardViewModel
    var acceptedQuest: SchemaV1.AcceptedQuest
    
    var body: some View {
        if acceptedQuest.reward.isRedeemed {
            AcceptedTicketCard()
        } else {
            Button(action: {
                //redeem
            }, label: {
                StandByTicketCard()
            })
        }
    }
}

struct AcceptedTicketCard: View {
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("御上先生")
                    .font(.title)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110)
            .background(.white)
            .clipShape(
                .rect(
                    topLeadingRadius: 15,
                    bottomLeadingRadius: 15,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                )
            )
            HStack(spacing: 0) {
                VStack(spacing: 5) {
                    Text("期日")
                        .font(.callout)
                    Text("12/31")
                        .font(.title3)
                }
            }
            .frame(width: 100, height: 110)
            .background(.gray.gradient)
            /// border
            .overlay(alignment: .leading) {
                Rectangle()
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 2, dash: [2, 4])
                    )
                    .foregroundColor(.black)
                    .frame(width: 2)/// 横幅をlineWidthと同じにして線にする
            }
            .clipShape(
                .rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 15,
                    topTrailingRadius: 15
                )
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .padding(.horizontal, 25)
    }
}

struct StandByTicketCard: View {
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("御上先生")
                    .font(.title)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110)
            .background(.white)
            .clipShape(
                .rect(
                    topLeadingRadius: 15,
                    bottomLeadingRadius: 15,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                )
            )
            HStack(spacing: 0) {
                VStack(spacing: 5) {
                    Text("期日")
                        .font(.callout)
                    Text("12/31")
                        .font(.title3)
                }
            }
            .frame(width: 100, height: 110)
            .background(.white)
            /// border
            .overlay(alignment: .leading) {
                Rectangle()
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 2, dash: [2, 4])
                    )
                    .foregroundColor(.black)
                    .frame(width: 2)/// 横幅をlineWidthと同じにして線にする
            }
            .clipShape(
                .rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 15,
                    topTrailingRadius: 15
                )
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .padding(.horizontal, 25)
    }
}


#Preview {
    AcceptedTicketCard()
        .background(.gray.gradient.opacity(0.2))
}
