import Foundation
import SwiftUI

struct QuestDetailsPage: View {
    @ObservedObject var vm: QuestDetailsViewModel
    
    @State private var showAlert = false
    @Binding var path: [QuestBoardNavigation]
    @Environment(\.dismiss) var dismiss
    
    init(questSlot: QuestSlot, path:  Binding<[QuestBoardNavigation]>) {
        vm = .init(questSlot: questSlot)
        self._path = .init(
            projectedValue: path
        )
    }
    
    var body: some View {
        let quest = vm.questSlot.quest
        let acceptedQuest = vm.questSlot.acceptedQuest
        let isAccepted = acceptedQuest != nil
        
        VStack(spacing: 0){
            VStack(alignment: .leading, spacing: 20) {
                // Back Navigation Arrow
                Button(
                    action: {
                        path.removeLast()
                    }, label: {
                        Image(systemName: "arrow.left")
                    }
                )
                .font(.title)
                .padding(.leading, 30)
                .tint(.black)
                Text(isAccepted ? acceptedQuest!.reward.text : quest.reward.text)
                    .font(.system(size: 40, weight: .bold))
                    .fontWeight(.bold)
                    .padding(.leading, 30)
                    .padding(.bottom, 45)
                if isAccepted {
                    PieChart(progress: acceptedQuest!.taskCompletionRate, barThick: 15, graphSize: 180, fontSize: 50, percentSize: .title2)
                        .frame(maxWidth: .infinity) // Centerよせ
                        .padding(.bottom, 70)
                } else {
                    Button(action: {
                        vm.acceptQuest()
                    }) {
                        ZStack {
                            Circle()
                                .stroke(Color.accentColor, lineWidth: 8)
                                .background(Color.blue.opacity(0.8), in: Circle())
                                .frame(width: 180, height: 180)
                            Text("開始")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .shadow(color: .white ,radius: 10, x: 0, y: 0)
                        }
                    }
                    .frame(maxWidth: .infinity) // Centerよせ
                    .padding(.bottom, 70)
                }

            }
            VStack(alignment: .leading, spacing: 0) {
                Text("やることリスト")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 30)
                    .padding(.top, 30)
                    .padding(.bottom, 15)
                Spacer()
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        if isAccepted {
                            ForEach(acceptedQuest!.acceptedTasks) { acceptedTask in
                                CheckBoxList(isSelected: acceptedTask.isCompleted, taskName: acceptedTask.text, isReadonly: false, isLabelOnly: false, toggleAction: { vm.toggleTaskCompleted(acceptedTask: acceptedTask) })
                                // TODO: isReadonlyの実装/過去日の場合のflagを上の階層から持ってくる
                            }
                        } else {
                            ForEach(quest.tasks) { task in
                                CheckBoxList(isSelected: false, taskName: task.text, isReadonly: true, isLabelOnly: true, toggleAction: { /* Do nothing */ })
                           }
                        }
                    }
                }
                if isAccepted {
                    if !acceptedQuest!.isAllTaskCompleted {
                        Button {
                            vm.discardAcceptedQuest()
                        } label: {
                            Text("諦める")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .foregroundStyle(.white)
                                .background(.red)
                                .padding(.horizontal, 30)
                                .padding(.bottom, 25)
                                .shadow(radius: 5, x: 2, y: 2)
                        }
                    } else {
                        
                        Button {
                            vm.reportQuestCompletion()
                            showAlert.toggle()
                        } label: {
                            Text("完了")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue.gradient, in: RoundedRectangle(cornerRadius: 30))
                                .padding(.horizontal, 30)
                                .padding(.bottom, 25)
                                .shadow(radius: 5, x: 2, y: 2)
                        }
                        .alert(isPresented: $showAlert) {
                            /// alertのdialogの見た目
                            VStack(spacing: 0) {
                                VStack(spacing: 8) {
                                    Circle()
                                        .frame(width: 150, height: 150)
                                    Text("御上先生")
                                        .font(.system(size: 35, weight: .bold))
                                        .padding(.bottom, 40)
                                }
                                VStack(spacing: 15) {
                                    Button {
                                        vm.redeemTicket()
                                        showAlert.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            path.removeLast()
                                        }
                                    } label: {
                                        Text("今すぐ遊ぶ")
                                            .font(.system(size: 23, weight: .bold))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .background(.green.gradient.opacity(0.8), in: RoundedRectangle(cornerRadius: 20))
                                            .padding(.horizontal, 35)
                                            .foregroundColor(.black)
                                    }
                                    Button {
                                        showAlert.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            path.removeLast()
                                        }
                                    } label: {
                                        Text("後で遊ぶ")
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .background(.gray.gradient.opacity(0.8), in: RoundedRectangle(cornerRadius: 20))
                                            .padding(.horizontal, 35)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.white, in: RoundedRectangle(cornerRadius: 45))
                            .padding(.horizontal, 35)
                            .padding(.vertical, 170)
                        } background: {
                            Rectangle()
                                .fill(.primary.opacity(0.35))
                        }
                    }
                } else {
                    // TODO: 受注ボタン
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(.gray.gradient.opacity(0.2))
        }
    }
}

#Preview {
    @State var binding: [QuestBoardNavigation] = []
    QuestDetailsPage(questSlot: QuestSlot(id: UUID(), quest: Quest(activatedDayOfWeeks: [:], reward: Reward(id: UUID(), text: "ご褒美内容"), tasks: [Task(id: UUID(), text: "タスク1")]), acceptedQuest: nil), path: $binding)
}
