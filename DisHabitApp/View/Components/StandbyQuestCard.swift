import Foundation
import SwiftUI

struct StandbyQuestCard: View {
    var manager: QuestSlotManager
    
    var quest: SchemaV1.Quest
//    var questSlotId: UUID

    var body: some View {
        ZStack {
            // NavigationLinkをカード全体に配置
//            NavigationLink(destination: AcceptedQuestDetailsPage(path: $path)) {
//                EmptyView() // 何も返さないView
//            }
//            .opacity(0) //
            // カード本体（UI表示部分）
            cardContent
        }
        .buttonStyle(.plain) // 青リンクを消す
        .padding(.horizontal, 25)
    }

    // カードのコンテンツを抽出
    private var cardContent: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(manager.questSlot.quest.reward.text)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 3)
                        .lineLimit(1)
                    Text("クリア率")
                        .font(.callout)
                }
                Spacer()
                Button(action: {
                    if manager.tense != .today { // 当日のみ操作可能
                        return;
                    }
                    
                    _Concurrency.Task {
                        await manager.acceptQuest()
                    }
                }) {
                    Image(systemName: "play.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 65, height: 65)
                        .background(.cyan.gradient.opacity(0.1), in: Circle())
                }
                // NavigationLinkが反応しないようにする
                .buttonStyle(.plain)
                .contentShape(Circle())
                .allowsHitTesting(true)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 30)
        }
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 15))
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 2)
                .fill(.gray.gradient)
        }
    }
}

#Preview {
    ContentView()
}
