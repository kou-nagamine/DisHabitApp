//
//  AlertView.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/03/27.
//

import SwiftUI

struct AlertView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showAlert: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Circle()
                    .frame(width: 150, height: 150)
                Text("御上先生")
                    .font(.system(size: 35, weight: .bold))
                    .padding(.bottom, 40)
            }
            /// Select buttons
            VStack(spacing: 15) {
                Button {
                    showAlert.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        dismiss()
                    }
                } label: {
                    Text("今すぐ遊ぶ")
                        .font(.system(size: 23, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.green.gradient.opacity(0.8), in: RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 35)
                        .foregroundColor(.black)
                }
                Button {
                } label: {
                    Text("後で遊ぶ")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.gray.gradient.opacity(0.8), in: RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 35)
                        .foregroundColor(.black)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white, in: RoundedRectangle(cornerRadius: 45))
        .padding(.horizontal, 35)
        .padding(.vertical, 170)
    }
}
