import Foundation
import SwiftUI

struct QuestBoardView: View {
   @ObservedObject var vm: QuestBoardViewModel
   
   init (vm: QuestBoardViewModel) {
       self.vm = vm
   }
   
   var screenWidth: CGFloat {
       guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
             let window = windowScene.windows.first else {
           return 0
       }
       return window.screen.bounds.width
   }
   
   var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 18) {
                ForEach(vm.dailyQuestBoard.questSlots) { questSlot in
                    VStack (spacing: 0) {
                        if let acceptedQuest = questSlot.acceptedQuest {
                            if acceptedQuest.isCompletionReported {
                                // チケットを表示
                                // 使用済みかどうかは子コンポーネント上で分岐させる
                                TicketCard(vm: vm, acceptedQuest: acceptedQuest)
                            } else {
                                // 進行中クエスト
                                AcceptedQuestCard(vm: vm, acceptedQuest: acceptedQuest)
                            }
                        } else {
                            // 未受注クエスト
                            StandbyQuestCard(vm: vm, quest: questSlot.quest)
                        }
                    }
                }.background(Color.gray.opacity(0.1))
//                ForEach(vm.questSlots) { questSlot in
//                    let acceptedQuest = questSlot.acceptedQuest
//                    VStack (spacing: 0) {
//                        HStack (spacing: 0){
//                            VStack(alignment: .leading, spacing: 8) {
//                                Text(questSlot.title)
//                                    .font(.title2)
//                                    .fontWeight(.bold)
//                                Text("クリア率：50%")
//                                    .font(.callout)
//                            }
//                            Spacer()
//                            if acceptedQuest {
//                                PieChart()
//                            } else {
//                                //スタートボタン
//                                Button (action: {
//                                    vm.acceptQuest(questSlotId: questSlot.id)
// //                                    Task {
// //                                        withAnimation(.spring(response: 0.3, dampingFraction: 1.0)) {
// //                                            questSlot.quest
// //                                            if  {
// //                                                selectedCardID = nil
// //                                            } else {
// //                                                selectedCardID = card.id
// //                                            }
// //                                        }
// //                                        try? await Task.sleep(nanoseconds: 600_000_000)
// //
// //                                        withAnimation(.spring(response: 0.5, dampingFraction: 1.0)) {
// //                                            selectCard = card
// //                                        }
// //                                    }
//                                }) {
//                                    Image(systemName: "play.circle")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .frame(width: 60, height: 60)
//                                        .background(.cyan.gradient.opacity(0.1), in: Circle())
//                                }
//                            }
//                        }
//                        .padding(.horizontal, 25)
//                        .padding(.vertical, 25)
//                        if acceptedQuest {
//                            QuestCaardProgressBar()
//                        }
//                    }
// //                    .background(card.color)
// //                    .matchedGeometryEffect(id: "background-\(card.id)", in: namespace)
// //                    .overlay {
// //                        RoundedRectangle(cornerRadius: 15)
// //                            .stroke(lineWidth: 4)
// //                            .fill(.gray.gradient)
// //                    }
// //                    .mask {
// //                        RoundedRectangle(cornerRadius: 15)
// //                    }
// //                    .padding(.horizontal, 25)
// //                    .onTapGesture {
// //                        withAnimation(.spring(response: 0.3, dampingFraction: 1.0)) {
// //                            selectCard = card
// //                        }
// //                    }
//                }
           }
       }
   }
}

#Preview {
    QuestBoardView(vm: QuestBoardViewModel(appDataService: AppDataService())).background(Color.gray)
}
