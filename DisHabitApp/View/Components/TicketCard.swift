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
    
    /// チケットカードは、Ticket Title AreaとTicket Tear Off Areaの二つの部品を組み合わせて作成しているので、高さをそれぞれで設定してます！！！！
    var body: some View {
        HStack(spacing: 0) {
            /// Ticket Title Area
            HStack(spacing: 0) {
                Text(manager.questSlot.acceptedQuest?.reward.text ?? "")
                    .font(.title2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110) /// 高さを指定
            .background(.white)
            ///  左のみが丸みを帯びるように切り取ってる
            .clipShape(
                .rect(
                    topLeadingRadius: 15,
                    bottomLeadingRadius: 15,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                )
            )
            /// Ticket Tear Off Area
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
            .frame(width: 100, height: 110) /// 高さを指定
//            .background(manager.questSlot.acceptedQuest?.reward.isRedeemed ?? false ? .gray.gradient : .white)
            .background(.blue) ///  ここが、チケットの切り取られる部分の色です今、青にしてる！！！！　何かしらがtrueかfalseになったら、グレイアウトをするコードを書いてくれー
            ///  右のみが丸みを帯びるように切り取ってる
            .clipShape(
                .rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 15,
                    topTrailingRadius: 15
                )
            )
            /// 切り取り線
            .overlay(alignment: .leading) {
                Rectangle()
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 2, dash: [2, 4])
                    )
                    .foregroundColor(.black)
                    .frame(width: 2)/// 横幅をlineWidthと同じにして線にする
            }
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
        /// card 全体のstroke
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
        .padding(.horizontal, 25)
    }
}
