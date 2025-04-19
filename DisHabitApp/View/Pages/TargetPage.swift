//
//  TaskPage.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/03/23.
//

import SwiftUI

struct TargetPage: View {
//    @StateObject var vm: ObjectivesPageViewModel = .init()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 30) {
                Text("目標一覧")
                    .padding(.top, 30)
                    .font(.largeTitle)
                ScrollView {
                    VStack(spacing: 20) {
//                        ForEach(vm.objectives) { objective in
//                            NavigationLink(destination: TaskPage(objective: objective)) {
//                                Text(objective.text)
//                                    .font(.title2)
//                                    .frame(maxWidth: .infinity)
//                                    .frame(height: 70)
//                                    .background(.gray.gradient.opacity(0.3), in: RoundedRectangle(cornerRadius: 20))
//                            }
//                        }
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
