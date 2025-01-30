//
//  QuestCard.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/01/31.
//

import Foundation
import SwiftUI

struct CardScrollView: View {
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
                    HStack (spacing: 0){
                        VStack(alignment: .leading, spacing: 7) {
                            Text(card.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("クリア率：50%")
                                .font(.callout)
                        }
                        
                    }
                    .frame(width: screenWidth * 0.8, height: 80, alignment: .topLeading)
                    .padding(.leading, 20)
                    .padding(.top, 15)
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
