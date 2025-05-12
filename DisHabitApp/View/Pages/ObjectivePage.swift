//
//  TaskPage.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/03/23.
//

import SwiftUI
import SwiftData

struct ObjectivePage: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query var objectives: [Objective]
    
    @StateObject private var router = Router.shared
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(alignment: .leading, spacing: 30) {
                Text("目標一覧")
                    .padding(.top, 30)
                    .font(.largeTitle)
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(objectives) { objective in
//                            NavigationLink(destination: TaskPage(objective: objective)) {
                                Text(objective.text)
                                    .font(.title2)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 70)
                                    .background(.gray.gradient.opacity(0.3), in: RoundedRectangle(cornerRadius: 20))
                                    .onTapGesture {
                                        Router.shared.path.append(objective)
                                    }
//                            }
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
            .navigationDestination(for: Objective.self) { objective in
                TaskPage(objective: objective)
            }
        }
    }
}

#Preview {
    ObjectivePage()
}
