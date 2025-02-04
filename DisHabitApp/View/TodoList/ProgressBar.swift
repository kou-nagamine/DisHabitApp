import Foundation
import SwiftUI

struct DetailProgressBar: View {
    @EnvironmentObject var taskCounter: DateModel
    
    var screenWidth: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.screen.bounds.width
    }
    
    var body: some View {
        VStack (spacing: 0){
            HStack (spacing: 0){
                Text("進行中")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("\(taskCounter.selection.count)/\(taskCounter.allSelectionNumber)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 10)
            HStack(spacing: 2) {
                ForEach(0..<taskCounter.allSelectionNumber, id: \.self) { index in
                    ProgressBarPart(
                        isFilled: index < taskCounter.selection.count,
                        height: 13,
                        CRadius: 7
                    )
                }
            }
            .frame(width: screenWidth - 60, height: 20)
        }
    }
}

struct QuestCaardProgressBar: View {
    @EnvironmentObject var questCardTaskCounter: DateModel
    
    var body: some View {
        VStack {
            HStack (spacing: 0){
                Text("進行中")
                    .font(.callout)
                    .fontWeight(.bold)
                Spacer()
                Text("\(questCardTaskCounter.selection.count)/\(questCardTaskCounter.allSelectionNumber)")
                    .font(.callout)
                    .fontWeight(.bold)
            }
            HStack(spacing: 3) {
                ForEach(0..<questCardTaskCounter.allSelectionNumber, id: \.self) { index in
                    ProgressBarPart(
                        isFilled: index < questCardTaskCounter.selection.count,
                        height: 8,
                        CRadius: 30
                    )
                }
            }
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 20)
    }
}

struct ProgressBarPart: View {
    var isFilled: Bool
    var height: CGFloat
    var CRadius: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: CRadius)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .foregroundStyle(isFilled ? .blue : .gray)
    }
}

#Preview {
    HomePageView()
        .environmentObject(DateModel())
}
