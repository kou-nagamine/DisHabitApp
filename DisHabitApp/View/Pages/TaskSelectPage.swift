//
//  TaskSelectPage.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/04/09.
//

import SwiftUI
import SwiftData

struct TaskSelectPage: View {
    @Binding var selectedTasks: [SchemaV1.StandbyTask]
    
    @Environment(\.dismiss) private var dismiss
    @Query var objectives: [SchemaV1.Objective]
    @Query var tasks: [SchemaV1.StandbyTask]
    
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
                                    CheckBoxList(isSelected: false, taskName: task.text, isReadonly: false, isLabelOnly: false, toggleAction: {})
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
    @State var selectedTasks: [SchemaV1.StandbyTask] = []
    TaskSelectPage(selectedTasks: $selectedTasks)
}
