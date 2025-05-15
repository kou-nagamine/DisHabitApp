import Foundation
import SwiftUI

struct QuestDetailsPage: View {
    var manager: QuestSlotManager
    
    @State private var showCompletionAlert = false
    @State private var showDiscardAlert = false
    @Environment(\.dismiss) var dismiss
    
    @State private var isExpended: Bool = false
    @State private var menuPosition: CGRect = .zero
    @Environment(\.colorScheme) private var colorScheme
    
    init(manager: QuestSlotManager) {
        self.manager = manager
    }
    
    var body: some View {
        let quest = manager.questSlot.quest
        let acceptedQuest = manager.questSlot.acceptedQuest
        let isAccepted = acceptedQuest != nil
        
        VStack(spacing: 0){
            VStack(alignment: .leading, spacing: 20) {
                // Back Navigation Arrow
                HStack(spacing: 0) {
                    Button(
                        action: {
                            Router.shared.path.removeLast()
                        }, label: {
                            Image(systemName: "arrow.left")
                        }
                    )
                    .font(.title)
                    .tint(.black)
                    Spacer(minLength: 0)
                    Button {
                        isExpended = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundStyle(isExpended ? colorScheme.currentColor : Color.primary)
                            .frame(width: 45, height: 45)
                            .background {
                                ZStack {
                                    Rectangle()
                                        .fill(.ultraThinMaterial)
                                    
                                    Rectangle()
                                        .fill(Color.primary.opacity(isExpended ? 1 : 0.03))
                                }
                                .clipShape(.circle)
                            }
                    }
                    .onGeometryChange(for: CGRect.self) {
                        $0.frame(in: .global)
                    } action: { newValue in
                        menuPosition = newValue
                    }
                }
                .padding(.horizontal, 30)
                .overlay(alignment: .topLeading) {
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .contentShape(.rect)
                            .onTapGesture {
                                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                                    isExpended = false
                                }
                            }
                            .allowsHitTesting(isExpended)
                        
                        ZStack {
                            if isExpended {
                                contextMenuStyle {
                                    MenuBarControls(manager: manager)
                                        .frame(width: 220, height: 120)
                                }
                                .offset(x: menuPosition.minX - 220 + menuPosition.width, y: menuPosition.maxY + 10)
                                .ignoresSafeArea()
                            }
                        }
                    }
                }
                Text(isAccepted ? acceptedQuest?.reward.text ?? "" : quest.reward.text)
                    .font(.system(size: 40, weight: .bold))
                    .fontWeight(.bold)
                    .padding(.leading, 30)
                    .padding(.bottom, 45)
                if isAccepted {
                    PieChart(progress: acceptedQuest?.taskCompletionRate ?? 0, barThick: 15, graphSize: 180, fontSize: 50, percentSize: .title2)
                        .frame(maxWidth: .infinity) // Centerよせ
                        .padding(.bottom, 70)
                } else {
                    Button(action: {
                        _Concurrency.Task {
                            await manager.acceptQuest()
                        }
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
                    .disabled(manager.tense != .today)
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
                        if let acceptedQuest = manager.questSlot.acceptedQuest {
                            ForEach(acceptedQuest.acceptedTasks) { acceptedTask in
                                CheckBoxList(
                                    isSelected: acceptedTask.isCompleted,
                                    taskName: acceptedTask.text,
                                    isReadonly: manager.tense != .today || acceptedQuest.isCompletionReported, // 当日かつクエスト未完了の場合のみ操作可能
                                    isLabelOnly: false,
                                    checkedStyle: .complete,
                                    toggleAction: {
                                        _Concurrency.Task {
                                            await manager.toggleTaskCompleted(acceptedTask: acceptedTask)
                                        }
                                })
                                // TODO: isReadonlyの実装/過去日の場合のflagを上の階層から持ってくる
                            }
                        } else {
                            ForEach(quest.tasks) { task in
                                CheckBoxList(isSelected: false, taskName: task.text, isReadonly: true, isLabelOnly: true, checkedStyle: .complete, toggleAction: { /* Do nothing */ })
                           }
                        }
                    }
                }
                if manager.tense == .today {
                    if let acceptedQuest = manager.questSlot.acceptedQuest {
                        if !acceptedQuest.isAllTaskCompleted {
                            Button {
                                showDiscardAlert.toggle()
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
                            .alert(isPresented: $showDiscardAlert) {
                                /// alertのdialogの見た目
                                VStack(spacing: 0) {
                                    Text("本当に諦めますか？")
                                    
                                    VStack(spacing: 15) {
                                        Button {
                                            _Concurrency.Task {
                                                await manager.discardAcceptedQuest()
                                                showDiscardAlert.toggle()
                                            }
                                        } label: {
                                            Text("諦める")
                                                .font(.system(size: 23, weight: .bold))
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 50)
                                                .background(.red.gradient.opacity(0.8), in: RoundedRectangle(cornerRadius: 20))
                                                .padding(.horizontal, 35)
                                                .foregroundColor(.black)
                                        }
                                        Button {
                                            showDiscardAlert.toggle()
                                        } label: {
                                            Text("もう少し頑張る")
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
                        } else {
                            if let acceptedQuest = manager.questSlot.acceptedQuest {
                                if !acceptedQuest.isCompletionReported {
                                    Button {
                                        _Concurrency.Task {
                                            await manager.reportQuestCompletion()
                                            showCompletionAlert.toggle()
                                        }
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
                                    .alert(isPresented: $showCompletionAlert) {
                                        /// alertのdialogの見た目
                                        VStack(spacing: 0) {
                                            VStack(spacing: 8) {
                                                Circle()
                                                    .frame(width: 150, height: 150)
                                                Text(acceptedQuest.reward.text)
                                                    .font(.system(size: 35, weight: .bold))
                                                    .padding(.bottom, 40)
                                            }
                                            VStack(spacing: 15) {
                                                Button {
                                                    _Concurrency.Task {
                                                        await manager.redeemTicket()
                                                        showCompletionAlert.toggle()
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                            Router.shared.path.removeLast()
                                                        }
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
                                                    showCompletionAlert.toggle()
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                        Router.shared.path.removeLast()
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
                            }
                        }
                    } else {
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(.gray.gradient.opacity(0.2))
        }
    }
}

struct MenuBarControls: View {
    var manager: QuestSlotManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            CustomButton(title: "クエストを編集", image: "square.and.pencil") {
                // Editボタン処理
                // 今回は動作させず
            }
            .foregroundStyle(.gray.opacity(0.3))
            CustomButton(title: "クエストを削除", image: "trash"){
                // Deleteボタン処理
                manager.archiveQuest()
                dismiss()
            }
            .foregroundStyle(.red)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    @ViewBuilder
    private func CustomButton(title: String, image: String, action: @escaping () -> () = { }) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.callout.bold())
                
                Spacer(minLength: 0)
                
                Image(systemName: image)
                    .font(.title3)
            }
            .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
//    @State var binding: [QuestBoardNavigation] = []
//    QuestDetailsPage(questSlot: QuestSlot(id: UUID(), quest: Quest(activatedDayOfWeeks: [:], reward: Reward(id: UUID(), text: "ご褒美内容"), tasks: [StandbyTask(id: UUID(), text: "タスク1")]), acceptedQuest: nil), path: $binding)
}
