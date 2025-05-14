//
//  TaskSelectPage.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/04/09.
//

import SwiftUI
import SwiftData

struct TaskSelectPage: View {
    @Binding var selectedTasks: [StandbyTask]
    
    @Environment(\.dismiss) private var dismiss
    @Query var objectives: [Objective]
    @Query var tasks: [StandbyTask]
    
    private func toggleAction(for task: StandbyTask) {
        if isTaskSelected(for: task) {
            selectedTasks.removeAll(where: { $0.id == task.id })
        } else {
            selectedTasks.append(task)
        }
    }
    
    private func isTaskSelected(for task: StandbyTask) -> Bool {
        return selectedTasks.contains(where: { $0.id == task.id })
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("タスクを選択する")
                .font(.largeTitle)
                .padding(.vertical, 30)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(objectives) { objective in
                        Text(objective.text)
                            .font(.title)
                            .padding(.leading, 30)
                        ForEach(tasks) { task in
                            /// checkedはselectedTasks.contains()で判定する
                            /// toggleActionでappend/removeする
                            if let taskobj = task.objective {
                                if taskobj.id == objective.id {
                                    CheckBoxList(isSelected: isTaskSelected(for: task), taskName: task.text, isReadonly: false, isLabelOnly: false, checkedStyle: .select,
                                        toggleAction: {
                                        toggleAction(for: task)
                                    })
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
}


#Preview {
    @State var selectedTasks: [StandbyTask] = []
    TaskSelectPage(selectedTasks: $selectedTasks)
}
