//
//  TicketCard.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/03/12.
//

import Foundation
import SwiftUI

struct TicketCard: View {
    var manager: QuestSlotManager
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(manager.questSlot.acceptedQuest?.reward.text ?? "")
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
                    if manager.questSlot.acceptedQuest?.reward.isRedeemed ?? false {
                        Text("使用済み")
                            .font(.callout)
                        Text(manager.questSlot.acceptedQuest?.reward.redeemedDate?.formatHourTime() ?? "")
                            .font(.title3)
                    } else {
                        Text("期日")
                            .font(.callout)
                        Text(manager.questSlot.board?.date.formatMonthDay() ?? "")
                            .font(.title3)
                    }

                }
            }
            .frame(width: 100, height: 110)
//            .background(manager.questSlot.acceptedQuest?.reward.isRedeemed ?? false ? .gray.gradient : .white)
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
            .allowsHitTesting(true)
            .onTapGesture {
                if manager.tense != .today {
                    return
                }
                if let acceptedQuest = manager.questSlot.acceptedQuest {
                    if acceptedQuest.reward.isRedeemed {
                        return
                    }
                    
                    acceptedQuest.redeemReward()
                }
            }
        }
        .overlay() {
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    .linearGradient(colors: [
                        .gray.opacity(0.5),
                        .gray.opacity(0.6),
                        .gray.opacity(0.7),
                        .gray.opacity(0.8)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .padding(.horizontal, 25)
    }
}
