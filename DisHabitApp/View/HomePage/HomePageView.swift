//
//  HomePageView.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/01/31.
//

import Foundation
import SwiftUI

struct CardData: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
}

struct HomePageView: View {
    @State private var selectedTab: ScrollableTabItem?
    @Environment(\.colorScheme) private var scheme
    /// Tab Progress
    @State private var tabProgress: CGFloat = 0
    @Namespace private var namespace
    
    // Carender
    @State private var currentDate: Date = .init()
    @State private var week: [Date.WeekDay] = []
    
    /// selected card
    @State private var selectCard: CardData? = nil
    
    // Card info
    @State private var cards: [CardData] = [
        CardData(title: "漫画1巻", color: .white),
        CardData(title: "ドラマ1話", color: .white),
        CardData(title: "ONE", color: .white),
        CardData(title: "ONE", color: .white),
        CardData(title: "ONE", color: .white),
        CardData(title: "ONE", color: .white)
    ]
    
    var screenWidth: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.screen.bounds.width
    }
    
    var body: some View {
        VStack (spacing: 0){
            /// Header
            VStack (spacing: 0) {
                //Header
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
                // Select Weekly
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
            /// Scroball Select
            VStack(spacing: 0) {
                TopTabBarView(selectedTab: $selectedTab, tabProgress: $tabProgress)
                /// Scroball Todo List
                GeometryReader {
                    let size = $0.size
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                            /// quest page
                            CardScrollView(cards: cards, namespace: namespace, selectCard: $selectCard)
                                .id(ScrollableTabItem.chats)
                                .containerRelativeFrame(.horizontal)
                            /// reward page
                            ScrollView(.vertical) {
                                VStack(spacing: 0){
                                    Text("to be continue")
                                }
                            }
                            .id(ScrollableTabItem.calls)
                            .containerRelativeFrame(.horizontal)
                            .border(Color.red)
                        }
                        .scrollTargetLayout()
                        .offsetX (completion: { value in
                            let progress = -value / (size.width * CGFloat(ScrollableTabItem.allCases.count - 1)) /// value is device width
                            tabProgress = max(min(progress, 1), 0)
                        })
                    }
                    .scrollPosition(id: $selectedTab)
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    .scrollClipDisabled()
                }
            }
            .padding(.top, 20)
            .background(.gray.opacity(0.1))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        // TodoPage
        .overlay {
            if let card = selectCard {
                TodoListView(
                    card: card,
                    namespace: namespace,
                    onDismiss: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectCard = nil
                        }
                    }
                )
            }
        }
    }
}



#Preview {
    HomePageView()
}
