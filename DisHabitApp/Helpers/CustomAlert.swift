//
//  CustomAlert.swift
//  DisHabitApp
//
//  Created by 長峯幸佑 on 2025/02/15.
//

import SwiftUI

extension View {
    @ViewBuilder
    func alert<Content: View, Background: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder background: @escaping () -> Background
    ) -> some View {
        self
            .modifier(
                AlertViewModifier(
                    isPresented: isPresented,
                    alertContent: content,
                    alertBackgroung: background
                )
            )
    }
}

fileprivate struct AlertViewModifier<AlertContent: View, AlertBackground: View> :ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder var alertContent: AlertContent
    @ViewBuilder var alertBackgroung: AlertBackground
    
    /// プロパティラッパー
    @State private var showFullScreenCover = false
    @State private var animationValue = false
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $showFullScreenCover) {
                ZStack {
                    if animationValue {
                        alertContent
                    }
                }
                .presentationBackground {
                    alertBackgroung
                }
                .task {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        animationValue = true
                    }
                }
            }
            .onChange(of: isPresented) {
                var transaction = Transaction()
                transaction.disablesAnimations = true
                
                if isPresented {
                    withTransaction(transaction) {
                        showFullScreenCover = true
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.1), completionCriteria: .removed) {
                        animationValue = false
                    } completion: {
                        withTransaction(transaction) {
                            showFullScreenCover = false
                        }
                    }
                }
            }
    }
}
