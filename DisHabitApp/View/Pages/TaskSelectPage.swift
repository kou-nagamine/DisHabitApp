//
//  TaskSelectPage.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/04/09.
//

import SwiftUI

struct TaskSelectPage: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 10) {
            Text("タスクを選択する")
                .font(.largeTitle)
                .padding(.vertical, 30)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("基本情報合格")
                        .font(.title)
                        .padding(.leading, 30)
                    CheckBoxList(isSelected: false, taskName: "英単語5個", isReadonly: false, isLabelOnly: false, toggleAction: {})
                    CheckBoxList(isSelected: false, taskName: "英単語5個", isReadonly: false, isLabelOnly: false, toggleAction: {})
                    CheckBoxList(isSelected: false, taskName: "英単語5個", isReadonly: false, isLabelOnly: false, toggleAction: {})
                }
                
            }
        }
    }
}


#Preview {
    TaskSelectPage()
}
