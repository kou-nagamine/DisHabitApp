//
//  TaskPage.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/03/23.
//

import SwiftUI

struct TargetPage: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 30) {
                Text("目標一覧")
                    .padding(.top, 30)
                    .font(.largeTitle)
                ScrollView {
                    VStack(spacing: 20) {
                        NavigationLink(destination: TaskPage()) {
                            Text("基本情報試験合格")
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                                .frame(height: 70)
                                .background(.gray.gradient.opacity(0.3), in: RoundedRectangle(cornerRadius: 20))
                        }
                        NavigationLink(destination: TaskPage()) {
                            Text("TOEIC700点")
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                                .frame(height: 70)
                                .background(.gray.gradient.opacity(0.3), in: RoundedRectangle(cornerRadius: 20))
                        }
                        Text("＋")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .frame(height: 70)
                            .background(.gray.gradient.opacity(0.3), in: RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    TargetPage()
}
