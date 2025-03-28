import Foundation
import SwiftUI

struct HomePage: View {
    @ObservedObject var vm: QuestBoardViewModel
    @State private var currentDate: Date = .init()
    @State private var week: [Date.WeekDay] = []
    @Namespace private var namespace
    @Binding var showTabBar: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 0) {
                    // 年月日
                    HStack (spacing: 0){
                        Text(currentDate.format("y/M/d"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 10)
                    
                    // 曜日選択
                    HStack(spacing: 0){
                        ForEach(week){ day in
                            VStack(spacing: 0) {
                                VStack(spacing: 0) {
                                    Text(day.date.format("E"))
                                        .font(.callout)
                                        .fontWeight(.medium)
                                        .textScale(.secondary)
                                        .padding(.top, 5)
                                    Text(day.date.format("dd"))
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .textScale(.secondary)
                                        .frame(width: 40, height: 35)
                                }
                                .foregroundStyle(Date().isSameDate(day.date, currentDate) ? .white : .gray)
                                .background(content: {
                                    if Date().isSameDate(day.date, currentDate) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.blue.gradient)
                                    }
                                })
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 2)
                                        .fill(.gray.gradient)
                                }
                                .mask {
                                    RoundedRectangle(cornerRadius: 8)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                    .padding(.bottom, 15)
                    .onAppear {
                        week = Date().fetchWeek()
                    }
                }
                QuestBoardView(vm: vm, namespace: namespace, showTabBar: $showTabBar) // 仮
            }
        }
// 詳細のoverlayが表示されているかどうかの変数をViewModelなどに作成する
//        .overlay {
//            if let card = selectCard {
//                TodoListView(
//                    card: card,
//                    namespace: namespace,
//                    onDismiss: {
//                        withAnimation(.easeInOut(duration: 0.3)) {
//                            selectCard = nil
//                        }
//                    }
//                )
//            }
//        }
    }
}
//
//#Preview {
//    HomePage(vm: QuestBoardViewModel(appDataService: AppDataService()))
//}
