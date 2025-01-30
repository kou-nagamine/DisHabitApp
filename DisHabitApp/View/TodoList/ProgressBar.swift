//
//  ProgressBar.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/01/31.
//

import Foundation
import SwiftUI

struct DetailProgressBar: View {
    
    var totalTasks: Int
    @State var completedTasks: Int
    
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
                Text("1/4")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 10)
            HStack(spacing: 2) {
                ForEach(0..<totalTasks, id: \.self) { index in
                    ProgressBarPart(
                        isFilled: index < completedTasks,
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
