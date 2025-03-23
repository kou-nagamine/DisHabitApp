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
                PieChart()
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 25)
        }
        .background(Color.gray.opacity(0.1))
        .matchedGeometryEffect(id: "background-\(acceptedQuest.id)", in: namespace)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 4)
                .fill(.gray.gradient)
        }
        .mask {
            RoundedRectangle(cornerRadius: 15)
        }
        .padding(.horizontal, 25)
//        .onTapGesture {
//            
//
//            //            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//            //                // 遷移アニメーション
//            //            }
//        }
    }
}

#Preview {
    HomePage(vm: QuestBoardViewModel(appDataService: AppDataService()))
}
