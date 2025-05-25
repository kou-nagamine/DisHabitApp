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
    let radius = 5
    
    /// チケットカードは、Ticket Title AreaとTicket Tear Off Areaの二つの部品を組み合わせて作成しているので、高さをそれぞれで設定してます！！！！
    var body: some View {
        HStack(spacing: 0) {
            /// Ticket Title Area
            HStack(spacing: 0) {
                Text(manager.questSlot.acceptedQuest?.reward.text ?? "")
                    .font(.title2)
                    .strikethrough(manager.questSlot.acceptedQuest?.reward.isRedeemed ?? false)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110) /// 高さを指定
            .background(/*Color.cyan.opacity(0.3)*/ .white)
            ///  左のみが丸みを帯びるように切り取ってる
            .clipShape(
                TicketTitleArea(notchRadius: 10, cornerRadius: 0)
            )
            .compositingGroup()
            .shadow(radius: 4, x: 2, y: 2)
            /// Ticket Tear Off Area
            VStack(spacing: 5) {
                if manager.questSlot.acceptedQuest?.reward.isRedeemed ?? false {
                    Text("使用済み")
                        .font(.callout)
                        .foregroundColor(.black.opacity(0.3))
                    Text(manager.questSlot.acceptedQuest?.reward.redeemedDate?.formatHourTime() ?? "")
                        .font(.title3)
                        .foregroundColor(.black.opacity(0.3))
                } else {
                    Text("期日")
                        .font(.callout)
                    Text(manager.questSlot.board?.date.formatMonthDay() ?? "")
                        .font(.title3)
                }

            }
            .frame(width: 100, height: 110) /// 高さを指定
            .background(manager.questSlot.acceptedQuest?.reward.isRedeemed ?? false ? .white : .cyan)
            .compositingGroup()
            .shadow(radius: 1, x: 3, y: 3)
            /// 切り取り線
            .overlay(alignment: .leading) {
                Rectangle()
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 2, dash: [2, 4])
                    )
                    .foregroundColor(.gray)
                    .frame(width: 2)/// 横幅をlineWidthと同じにして線にする
            }
            .clipShape(
                TicketTearOffArea(notchRadius: 10, cornerRadius: 0)
            )
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
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 25)
    }
}
