import Foundation
import SwiftUI

struct AcceptedQuestCard: View {
    @ObservedObject var vm: QuestBoardViewModel
    var acceptedQuest: AcceptedQuest
    let namespace: Namespace.ID
    
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
                PieChart(progress: 0.5, barThick: 7, graphSize: 60, fontSize: 20, percentSize: .caption2)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 25)
        }
        .background(.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 15))
        .matchedGeometryEffect(id: "background-\(acceptedQuest.id)", in: namespace)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 2)
                .fill(.gray.gradient)
        }
        .padding(.horizontal, 25)
        .onTapGesture {
//            
//
//            //            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//            //                // 遷移アニメーション
//            //            }
        }
    }
}

#Preview {
    HomePage(vm: QuestBoardViewModel(appDataService: AppDataService()))
}
