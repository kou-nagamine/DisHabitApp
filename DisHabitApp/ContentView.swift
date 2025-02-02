//
//  ContentView.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/01/31.
//

import SwiftUI

struct ContentView: View {
    
    @Namespace var testNamespace
    
    var body: some View {
        TodoListView(
            card: CardData(title: "漫画1巻", color: .white),
            namespace: testNamespace,
            onDismiss: {
                print("test")
            }
        )
    }
}

#Preview {
    ContentView()
}
