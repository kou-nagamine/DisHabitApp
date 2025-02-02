//
//  QuestCard.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/01/31.
//

import Foundation
import SwiftUI

struct CardScrollView: View {
    @State private var selectedCardID: UUID? = nil
    let cards: [CardData] // 外部からカードデータを受け取る
    let namespace: Namespace.ID // 外部からNamespaceを受け取る
    @Binding var selectCard: CardData? // 選択したカードを管理するためのBinding
    
    var screenWidth: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.screen.bounds.width
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 18) {
                ForEach(cards) { card in
                    VStack (spacing: 0) {
                        HStack (spacing: 0){
                            VStack(alignment: .leading, spacing: 8) {
                                Text(card.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("クリア率：50%")
                                    .font(.callout)
                            }
                            Spacer()
                            Image(systemName: "play")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(20)
                                .padding(.leading, 5)
                                .background(.cyan.gradient.opacity(0.1), in: Circle())
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 4)
                                        .fill(.gray.gradient)
                                }
                                .mask {
                                    Circle()
                                }
                                .padding(23)
                                .onTapGesture {
                                    Task {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 1.0)) {
                                            if selectedCardID == card.id {
                                                selectedCardID = nil
                                            } else {
                                                selectedCardID = card.id
                                            }
                                        }
                                        try? await Task.sleep(nanoseconds: 600_000_000)

                                        withAnimation(.spring(response: 0.5, dampingFraction: 1.0)) {
                                            selectCard = card
                                        }
                                    }
                                }
                        }
                        Spacer()
                        if selectedCardID == card.id {
                            VStack (spacing: 5){
                                HStack (spacing: 0){
                                    Text("進行中")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("1/4")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .padding(.trailing, 40)
                                }
                                HStack (spacing: 1){
                                    ForEach(0..<4, id: \.self) { index in
                                        ProgressBarPart(
                                            isFilled: index < 1,
                                            width: (screenWidth * 0.71) / CGFloat(4),
                                            height: 8,
                                            CRadius: 30
                                        )
                                    }
                                    Spacer()
                                }
                            }
                            .padding(.bottom, 15)
                        }
                    }
                    .frame(width: screenWidth * 0.8, height: selectedCardID == card.id ? 140 : 80, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.vertical, 10)
                    .background(card.color)
                    .matchedGeometryEffect(id: "background-\(card.id)", in: namespace)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 4)
                            .fill(.gray.gradient)
                    }
                    .mask {
                        RoundedRectangle(cornerRadius: 15)
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 1.0)) {
                            selectCard = card
                        }
                    }
                }
            }
            .padding(.bottom, 80)
        }
    }
}

#Preview {
    HomePageView()
}
