//
//  TaskPage.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/03/27.
//

import SwiftUI

struct TaskPage: View {
    var objective: SchemaV1.Objective
//    @ObservedObject var vm: TasksPageViewModel
    
    init(objective: SchemaV1.Objective) {
        self.objective = objective
//        self.vm = .init(selectedObjective: objective)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
//            Text(vm.selectedObjective.text)
//                .font(.system(size: 30, weight: .bold))
//                .padding(.top, 20)
//                .padding(.bottom, 35)
//                .padding(.leading, 30)
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
//                    ForEach(vm.tasks) { task in
//                        Text(task.text)
//                            .font(.system(size: 18, weight: .bold))
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 55)
//                            .background(.white, in: RoundedRectangle(cornerRadius: 15))
//                            .padding(.trailing, 200)
//                            .overlay {
//                                RoundedRectangle(cornerRadius: 15)
//                                    .stroke(lineWidth: 2)
//                                    .fill(.gray.gradient)
//                                    .padding(.horizontal, 30)
//                            }
//
//                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
