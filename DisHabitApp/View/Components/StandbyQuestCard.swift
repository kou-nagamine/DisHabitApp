import Foundation
import SwiftUI

struct StandbyQuestCard: View {
    var manager: QuestSlotManager
    @Binding var showTabBar: Bool
    
    var quest: Quest
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
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text(manager.questSlot.quest.activatedDayOfWeeks.weeklyOccasionDescription())
                        .font(.callout)
                }
                Spacer()
                Button(action: {
                    if manager.tense != .today { // 当日のみ操作可能
                        return;
                    }
                    
                    _Concurrency.Task {
                        await manager.acceptQuest()
                        try await Task.sleep(for: .milliseconds(250))
                        showTabBar = false
                        Router.shared.path.append(manager)
                    }
                }) {
                    Image(systemName: "play.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .background(.white, in: Circle())
                        .foregroundColor(.cyan.opacity(0.8))
                }
                // NavigationLinkが反応しないようにする
                .buttonStyle(.plain)
                .contentShape(Circle())
                .allowsHitTesting(true)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 25)
        }
        .background(.cyan.opacity(0.2), in: RoundedRectangle(cornerRadius: 15))
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 2)
                .fill(.cyan.opacity(0.3).gradient)
        }
    }
}

#Preview {
    ContentView()
}
