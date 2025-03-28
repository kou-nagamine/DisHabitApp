import Foundation
import SwiftUI

struct StandbyQuestCard: View {
    @ObservedObject var vm: QuestBoardViewModel
    var quest: Quest
    var questSlotId: UUID

    var body: some View {
        ZStack {
            // NavigationLinkをカード全体に配置
            NavigationLink(destination: AcceptedQuestDetailsPage()) {
                EmptyView() // 何も返さないView
            }
            .opacity(0) //
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
                    Text(quest.reward.text)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("クリア率")
                        .font(.callout)
                }
                Spacer()
                Button(action: {
                    // ボタン固有の処理
                    vm.acceptQuest(questSlotId: questSlotId)
                }) {
                    Image(systemName: "play.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .background(.cyan.gradient.opacity(0.1), in: Circle())
                }
                // NavigationLinkが反応しないようにする
                .buttonStyle(.plain)
                .contentShape(Circle())
                .allowsHitTesting(true)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 25)
        }
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 15))
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 2)
                .fill(.gray.gradient)
        }
    }
}

//
//struct StandbyQuestCard: View {
//    @ObservedObject var vm: QuestBoardViewModel
//    var quest: Quest
//    var questSlotId: UUID
//    
//    @State var isStarted: Bool = false
//    
//    var body: some View {
//        VStack (spacing: 0) {
//            HStack (spacing: 0){
//                VStack(alignment: .leading, spacing: 8) {
//                    Text(quest.reward.text)
//                        .font(.title2)
//                        .fontWeight(.bold)
//                    Text("クリア率：50%")
//                        .font(.callout)
//                }
//                Spacer()
//                Button (action: {
//                    vm.acceptQuest(questSlotId: questSlotId)
////                    Task {
////                        withAnimation(.spring(response: 0.3, dampingFraction: 1.0)) {
////                            
////                        }
////                        try? await Task.sleep(nanoseconds: 600_000_000)
////
////                        withAnimation(.spring(response: 0.5, dampingFraction: 1.0)) {
////
////                        }
////                    }
//                }) {
//                    Image(systemName: "play.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 60, height: 60)
//                        .background(.cyan.gradient.opacity(0.1), in: Circle())
//                }
//            }
//            .padding(.horizontal, 25)
//            .padding(.vertical, 25)
//        }
//        .background(Color.gray.opacity(0.2))
////        .matchedGeometryEffect(id: "background-\(quest.id)", in: namespace)
//        .overlay {
//            RoundedRectangle(cornerRadius: 15)
//                .stroke(lineWidth: 4)
//                .fill(.gray.gradient)
//        }
//        .mask {
//            RoundedRectangle(cornerRadius: 15)
//        }
//        .padding(.horizontal, 25)
//        .onTapGesture {
////            withAnimation(.spring(response: 0.3, dampingFraction: 1.0)) {
////            }
//        }
//
//        
//        
////        VStack {
////            HStack() {
////                VStack(alignment: .leading, spacing: 8) {
////                    Text(quest.reward.text)
////                        .font(.title2)
////                        .fontWeight(.bold)
////                    Text("月, 火")
////                }
////                Spacer()
////                Button (action: {
////                    vm.acceptQuest(questSlotId: questSlotId)
////                }) {
////                    Image(systemName: "play.circle")
////                        .resizable()
////                        .aspectRatio(contentMode: .fit)
////                        .frame(width: 60, height: 60)
////                        .background(.cyan.gradient.opacity(0.1), in: Circle())
////                }
////            }
////        }
//    }
//}
//
//#Preview {
//    HomePage(vm: QuestBoardViewModel(appDataService: AppDataService()))
//}
