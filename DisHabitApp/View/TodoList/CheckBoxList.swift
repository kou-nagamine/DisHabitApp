//
//  CheckBoxList.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/01/31.
//

import Foundation
import SwiftUI

struct ParentView: View {
    @State private var selection: Set<Option> = []

    var body: some View {
        MultiCheckBox()
    }
}

struct MultiCheckBox: View {
//    @Binding var selection: Set<T>
    
//    var options: [T]
//    var keyPath: KeyPath<T, String>
    
    var screenWidth: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.screen.bounds.width
    }
    
    var body: some View {
        VStack (spacing: 20){
            ForEach(0..<4, id: \.self) { option in
//                let isSelected = selection.contains(option)
                
                HStack(alignment: .center, spacing: 8) {
                    // checkbox
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(Color.green)
                        .frame(width: 20, height: 20)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.clear, lineWidth: 1)
                        }
                        .overlay {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.white)
                                .font(.system(size: 12, weight: .bold))
                        }
                        .padding(.leading, 20)
                    // text
                    Text("aaaa")
                        .font(.body)
                        .foregroundStyle(.primary)
                        .strikethrough(true)
                        .padding(.leading, 10)
                    Spacer()
                }
                .frame(width: screenWidth - 60, height: 60)
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                
//                .onTapGesture {
//                    if isSelected {
//                        selection.remove(option)
//                    } else {
//                        selection.insert(option)
//                    }
//                }
            }
        }
        .safeAreaPadding(.bottom, 140)
    }
}

public enum Option: CaseIterable {
    
    case pop
    case classical
    case metal
    case rock
    
    var name: String {
        switch self {
        case .pop:
            return "Pop"
        case .classical:
            return "Classical"
        case .metal:
            return "Metal"
        case .rock:
            return "Rock"
        }
    }
}
