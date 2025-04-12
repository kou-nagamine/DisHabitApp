import Foundation
import SwiftUI

struct QuestBoardView: View {
    @StateObject var vm: QuestBoardViewModel = QuestBoardViewModel()
    @Binding var showTabBar: Bool
    @Binding var path: [QuestBoardNavigation]
   
    init (
        showTabBar: Binding<Bool>,
        path: Binding<[QuestBoardNavigation]>
    ) {
        self._showTabBar = showTabBar
        self._path = path
    }
   
    var screenWidth: CGFloat {
       guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
             let window = windowScene.windows.first else {
           return 0
       }
       return window.screen.bounds.width
    }
   
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // タイトル
            Text("楽しいこと習慣")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 18)
                .padding(.leading, 20)
                .padding(.bottom, 18)
            // クエストリスト
            ScrollView(.vertical) {
                Spacer() // 要検討
                VStack(spacing: 25) {
                    ForEach(vm.dailyQuestBoard.questSlots) { questSlot in
                        if let acceptedQuest = questSlot.acceptedQuest {
                            if acceptedQuest.isCompletionReported {
                                TicketCard(vm: vm, acceptedQuest: acceptedQuest)
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            showTabBar = false
                                        }
                                        path.append(.questDetails(questSlot: questSlot))
                                    }
                            } else {
                                AcceptedQuestCard(vm: vm, acceptedQuest: acceptedQuest)
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            showTabBar = false
                                        }
                                        path.append(.questDetails(questSlot: questSlot))
                                    }
                            }
                        } else {
                            StandbyQuestCard(vm: vm, quest: questSlot.quest, questSlotId: questSlot.id)
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        showTabBar = false
                                    }
                                    path.append(.questDetails(questSlot: questSlot))
                                }
                        }
                    }
                    #if DEBUG
                    Button {
                        vm.debug_ResetAcceptedQuests()
                    } label: {
                        Text("DEBUG:受注リセット")
                    }
                    #endif
                    /// Spacer
                    VStack {
                        Text("")
                    }
                    .frame(height: 100)
                }
            }
            //.padding(.bottom, 100)
            .frame(maxWidth: .infinity)
            
        }
    }
}

#Preview {
    ContentView()
}

