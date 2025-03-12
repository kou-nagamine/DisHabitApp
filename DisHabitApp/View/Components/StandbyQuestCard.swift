import Foundation
import SwiftUI

struct StandbyQuestCard: View {
    @ObservedObject var vm: QuestBoardViewModel
    var quest: Quest
    
    var body: some View {
        VStack {
            Text("Standby Quest Card")
            Text(quest.reward.text)
            
        }
    }
}

#Preview {
    QuestBoardView(vm: QuestBoardViewModel(appDataService: AppDataService()))
}
