import Foundation
import SwiftUI

struct AcceptedQuestDetailsPage: View {
    @State private var showAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0){
            VStack(alignment: .leading, spacing: 20) {
                // Back Navigation Arrow
                Button(
                    action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                    }
                )
                .font(.title)
                .padding(.leading, 30)
                .tint(.black)
                Text("御上先生")
                    .font(.system(size: 40, weight: .bold))
                    .fontWeight(.bold)
                    .padding(.leading, 30)
                    .padding(.bottom, 45)
                PieChart(progress: 0.5, barThick: 15, graphSize: 180, fontSize: 50, percentSize: .title2)
                    .frame(maxWidth: .infinity) // Centerよせ
                    .padding(.bottom, 70)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("やることリスト")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 30)
                    .padding(.top, 30)
                Spacer()
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        CheckBoxList(isSelected: false, taskName: "英単語5個")
                        CheckBoxList(isSelected: false, taskName: "基本情報２問")
                        // CheckBoxList(isSelected: false, taskName: "英単語5個")
                        //CheckBoxList(isSelected: false, taskName: "英単語5個")
                    }
                }
                .overlay (alignment: .bottom){
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
                        VStack {
                            Text("aaa")
                            Button("戻る") {
                                showAlert.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    dismiss()
                                }
                            }
                        }
                    } background: {
                        Rectangle()
                            .fill(.primary.opacity(0.35))
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(.gray.gradient.opacity(0.2))
        }
    }
}

#Preview {
    AcceptedQuestDetailsPage()
}
