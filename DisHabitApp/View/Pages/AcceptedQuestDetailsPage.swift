import Foundation
import SwiftUI

struct AcceptedQuestDetailsPage: View {
    @ObservedObject var vm: AcceptedQuestDetailsViewModel
    
    @State private var showAlert = false
    @Binding var path: [QuestBoardNavigation]
    @Environment(\.dismiss) var dismiss
    
    init(acceptedQuest: AcceptedQuest, path:  Binding<[QuestBoardNavigation]>) {
        vm = .init(acceptedQuest: acceptedQuest)
        self._path = .init(
            projectedValue: path
        )
    }
    
    var body: some View {
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
                Text(vm.acceptedQuest.reward.text)
                    .font(.system(size: 40, weight: .bold))
                    .fontWeight(.bold)
                    .padding(.leading, 30)
                    .padding(.bottom, 45)
                PieChart(progress: 0.5, barThick: 15, graphSize: 180, fontSize: 50, percentSize: .title2)
                    .frame(maxWidth: .infinity) // Centerよせ
                    .padding(.bottom, 70)
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
                        CheckBoxList(isSelected: false, taskName: "英単語5個")
                        CheckBoxList(isSelected: false, taskName: "基本情報２問")
                        CheckBoxList(isSelected: false, taskName: "英単語5個")
                        //CheckBoxList(isSelected: false, taskName: "英単語5個")
                    }
                }
                    Button {
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
            .navigationBarBackButtonHidden(true)
            .background(.gray.gradient.opacity(0.2))
        }
    }
}

#Preview {
    ContentView()
}
