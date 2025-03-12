import Foundation
import SwiftUI

struct StandbyQuestCard: View {
    @ObservedObject var vm: QuestBoardViewModel
    var quest: Quest
    var questSlotId: UUID
    
    var body: some View {
        VStack {
            HStack() {
                VStack(alignment: .leading, spacing: 8) {
                    Text(quest.reward.text)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("何これ")
                }
                Spacer()
                Button (action: {
                    vm.acceptQuest(questSlotId: questSlotId)
                }) {
                    Image(systemName: "play.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .background(.cyan.gradient.opacity(0.1), in: Circle())
                }
            }
        }
    }
}

#Preview {
    QuestBoardView(vm: QuestBoardViewModel(appDataService: AppDataService()))
}
