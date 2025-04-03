import Foundation
import SwiftUI

struct AcceptedQuestCard: View {
    @ObservedObject var vm: QuestBoardViewModel
    var acceptedQuest: AcceptedQuest
    
    var body: some View {
        VStack (spacing: 0) {
            HStack (spacing: 0){
                VStack(alignment: .leading, spacing: 8) {
                    Text(acceptedQuest.reward.text)
                        .font(.title2)
                        .fontWeight(.bold)
                    HStack {
                        Text("クリア率")
                            .font(.callout)
                    }
                }
                Spacer()
                PieChart(progress: acceptedQuest.taskCompletionRate, barThick: 7, graphSize: 60, fontSize: 20, percentSize: .caption2)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 25)
        }
        .background(.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 15))
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 2)
                .fill(.gray.gradient)
        }
        .padding(.horizontal, 25)
    }
}

#Preview {
    ContentView()
}
