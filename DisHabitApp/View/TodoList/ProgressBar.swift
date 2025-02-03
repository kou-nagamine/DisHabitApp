//
//  ProgressBar.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/01/31.
//

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
                        width: (screenWidth - 60) / CGFloat(4),
                        height: 15,
                        CRadius: 30
                    )
                }
            }
            .frame(width: screenWidth - 60, height: 20)
        }
    }
}

struct QuestCaardProgressBar: View {
    @EnvironmentObject var questCardTaskCounter: DateModel
    
    var screenWidth: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.screen.bounds.width
    }
    
    var body: some View {
        VStack (spacing: 5){
            HStack (spacing: 0){
                Text("進行中")
                    .font(.callout)
                    .fontWeight(.bold)
                Spacer()
                Text("\(questCardTaskCounter.selection.count)/\(questCardTaskCounter.allSelectionNumber)")
                    .font(.callout)
                    .fontWeight(.bold)
                    .padding(.trailing, 40)
            }
            HStack (spacing: 1){
                ForEach(0..<questCardTaskCounter.allSelectionNumber, id: \.self) { index in
                    ProgressBarPart(
                        isFilled: index < questCardTaskCounter.selection.count,
                        width: (screenWidth * 0.71) / CGFloat(4),
                        height: 8,
                        CRadius: 30
                    )
                }
                Spacer()
            }
        }
    }
}

struct ProgressBarPart: View {
    var isFilled: Bool
    var width: CGFloat
    var height: CGFloat
    var CRadius: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: CRadius)
            .frame(width: width, height: height)
            .foregroundStyle(isFilled ? .blue : .gray)
    }
}

#Preview {
    HomePageView()
        .environmentObject(DateModel())
}
