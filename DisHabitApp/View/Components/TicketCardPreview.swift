import Foundation
import SwiftUI

struct TicketCardPreview: View {
    let rewardText: String
    let radius = 5
    
    /// チケットカードは、Ticket Title AreaとTicket Tear Off Areaの二つの部品を組み合わせて作成しているので、高さをそれぞれで設定してます！！！！
    var body: some View {
        HStack(spacing: 0) {
            /// Ticket Title Area
            HStack(spacing: 0) {
                Text(rewardText)
                    .font(.title2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 110) /// 高さを指定
            .background(/*Color.cyan.opacity(0.3)*/ .white)
            /// 切り取り線
            .overlay(alignment: .trailing) {
                Rectangle()
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 2, dash: [2, 4])
                    )
                    .foregroundColor(.gray)
                    .frame(width: 2)/// 横幅をlineWidthと同じにして線にする
            }
            ///  左のみが丸みを帯びるように切り取ってる
            .clipShape(
                TicketTitleArea(notchRadius: 10, cornerRadius: 0)
            )
            .compositingGroup()
            .shadow(radius: 4, x: 2, y: 2)
            /// Ticket Tear Off Area
            VStack(spacing: 5) {
                Text("期日")
                    .font(.callout)
                Text(Date().formatMonthDay())
                    .font(.title3)
            }
            .frame(width: 100, height: 110) /// 高さを指定
            .background(.cyan)
            .compositingGroup()
            .shadow(radius: 1, x: 3, y: 3)
            .clipShape(
                TicketTearOffArea(notchRadius: 10, cornerRadius: 0)
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 25)
    }
}
