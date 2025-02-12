//
//  Dialog.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/02/04.
//

import SwiftUI

struct CustomDialog: View {
    var title: String
    var content: String?
    var image: Config
    var button1: Config
    var button2: Config?
    var addsTextField: Bool = false
    var textFieldHint: String = ""
    
    // State Properties
    @State private var text: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: image.content)
                .font(.title)
                .frame(width: 65, height: 65)
                .background(image.tint.gradient, in: .circle)
                .background {
                    Circle()
                        .stroke(.background, lineWidth: 8)
                }
            Text(title)
                .font(.title3.bold())
            
            if let content {
                Text(content)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundStyle(.gray)
            }
            
            if addsTextField {
                TextField(textFieldHint, text: $text)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.1))
                    }
            }
            
            ButtonView(button1)
            
            if let button2 {
                ButtonView(button2)
                    .padding(.top, 5)
            }
        }
        .padding([.horizontal, .bottom], 15)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
        }
        .frame(maxWidth: 310)
        .compositingGroup()
    }
    
    @ViewBuilder
    private func ButtonView(_ config: Config) -> some View {
        Button {
            config.action(addsTextField ? text : "")
        } label: {
            Text(config.content)
                .fontWeight(.bold)
                .foregroundStyle(config.foreground)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(config.tint.gradient, in: .rect(cornerRadius: 10))
        }
    }
    
    struct Config {
        var content: String
        var tint: Color
        var foreground: Color
        var action: (String) -> () = { _ in }
    }
}

#Preview {
    CustomDialog(
        title: "Foldr Name",
        content: "Enter a file Name",
        image: .init(content: "folder.fill.badge.plus", tint: .blue, foreground: .white),
        button1: .init(content: "Save Folder", tint: .blue, foreground: .white, action: { folder in print(folder)
        }),
        button2: .init(content: "Cancel", tint: .red, foreground: .white),
        addsTextField: true,
        textFieldHint: "Presonal Documents"
    )
}
