import Foundation
import SwiftUI

struct AcceptedQuestCard: View {
    @ObservedObject var vm: QuestBoardViewModel
    var acceptedQuest: AcceptedQuest
    
    var body: some View {
        VStack() {
            HStack() {
                VStack(alignment: .leading, spacing: 8) {
                    Text(acceptedQuest.reward.text)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("何だろうね")
                    Spacer()
                }
                //                  PieChart()
                Text("進行率")
            }
//          QuestCaardProgressBar()
            Text("Bottom Progress Bar")
        }
    }
}
