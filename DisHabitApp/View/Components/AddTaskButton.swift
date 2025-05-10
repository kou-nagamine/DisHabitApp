//
//  AddTaskButton.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/04/09.
//

import SwiftUI

struct AddTaskButton: View {
    @Binding var selectedTasks: [StandbyTask]
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "plus")
                .font(.system(size: 30, weight: .medium))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 65)
        .background(.white, in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .gray.opacity(0.2), radius: 2, x: 2, y: 2)
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(lineWidth: 3)
                .fill(.gray.gradient.opacity(0.2))
        }
        .padding(.horizontal, 30)
        .onTapGesture {
            isPresented.toggle()
        }
        .sheet(isPresented: $isPresented) {
            TaskSelectPage(selectedTasks: $selectedTasks)
        }
    }
}

#Preview {
    @State var selectedTasks: [StandbyTask] = []
    AddTaskButton(selectedTasks: $selectedTasks)
}
