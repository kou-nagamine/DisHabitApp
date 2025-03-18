import Foundation
import SwiftUI

struct CardScrollView: View {
    @State private var selectedCardID: UUID? = nil
    let cards: [CardData]
    let namespace: Namespace.ID
    @Binding var selectCard: CardData?
    
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
                            if selectedCardID == card.id {
                                PieChart()
                            } else {
                                Button (action: {
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
                                }) {
                                    Image(systemName: "play.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .background(.cyan.gradient.opacity(0.1), in: Circle())
                                }
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 25)
//                        if selectedCardID == card.id {
//                            QuestCaardProgressBar()
//                        }
                    }
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
                    .padding(.horizontal, 25)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 1.0)) {
                            selectCard = card
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomePageView()
        .environmentObject(DateModel())
}
