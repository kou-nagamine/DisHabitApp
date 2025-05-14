//
//  contextMenuStyle.swift
//  DisHabitApp
//
//  Created by 長峯 幸佑 on 2025/05/14.
//

import SwiftUI

struct contextMenuStyle<Content: View>: View {
    var cornerRadius: CGFloat = 30
    @ViewBuilder var content: Content
    
    /// View Properties
    @State private var viewSize: CGSize = .zero
    var body: some View {
        content
            .foregroundStyle(.black)
            .clipShape(.rect(cornerRadius: cornerRadius, style: .continuous))
            .contentShape(.rect(cornerRadius: cornerRadius, style: .continuous))
            .background {
                BackgroundView()
            }
            .compositingGroup() /// 全てまとめて、個別に影がかかるバクを解消するよう
            /// shadowの設定
            .shadow(color: .black.opacity(0.15), radius: 8, x: 8, y: 8)
            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: { newValue in
                viewSize = newValue
            }
    }
    
    /// VisionOS Style Background
    @ViewBuilder
    private func BackgroundView() -> some View {
        ZStack {
            /// 角丸長方形の囲い線
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(.thinMaterial, style: .init(lineWidth: 3, lineCap: .round, lineJoin: .round))
            /// ガラスのstyleで塗りつぶされた角丸の長方形
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial.shadow(.inner(color: .black.opacity(0.2), radius: 10)))
        }
        .compositingGroup() /// 個別に影がかかるバクを解消するように上のZStackをまとめる
        .environment(\.colorScheme, .light)
    }
}

extension ColorScheme {
    var currentColor: Color {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        default: return .clear
        }
    }
}
