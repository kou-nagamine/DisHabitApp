//
//  TabBar.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/03/23.
//

import SwiftUI

struct TabBar: View {
    @Binding var activeTab: TabItem
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(maxWidth: 25)
            TabButton(.home)
            AddQuestButton()
            TabButton(.task)
            Spacer()
                .frame(maxWidth: 25)
        }
        /// Tabbar全体のレイアウト調整
        .background{
            TabBarShape()
                .fill(.white)
                .frame(height: 95)
                .shadow(color: Color.gray, radius: 4, x: 3, y: 3)
            
        }
        .padding(.horizontal, 8)
    }
    
    /// TabButton
    @ViewBuilder
    func TabButton(_ tab: TabItem) -> some View {
        let isActive = activeTab == tab
        
        VStack(spacing: 5) {
            Image(systemName: tab.symbolImage)
                .symbolVariant(.fill)
                .font(.title)
                .frame(width: 30, height: 30)
                .foregroundStyle(isActive ? .blue : .black)
            Text(tab.rawValue)
                .font(.footnote)
                .foregroundStyle(isActive ? .blue : .black)
        }
        /// 各ボタンの横幅をinifinityにすることで等間隔で並ぶ
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 10)
        .padding(.bottom, 5)
        .contentShape(.rect)
        .onTapGesture {
            activeTab = tab
        }
    }
    
    /// AddQuestButton
    @ViewBuilder
    func AddQuestButton() -> some View {
        
        VStack(spacing: 3) {
            Image(systemName: "folder")
                .symbolVariant(.fill)
                .font(.title)
                .frame(width: 30, height: 30)
                .foregroundStyle(.white)
        }
        .frame(width: 72, height: 72)
        .background {
            Circle()
                .fill(.blue.gradient)
                .shadow(color: Color.gray, radius: 2, x: 1, y: 1)
        }
        /// 各ボタンの横幅をinifinityにすることで等間隔で並ぶ
        .frame(maxWidth: .infinity, alignment: .center)
        .contentShape(.rect)
        .offset(y: -47)
        .onTapGesture {
        }
    }
}

struct TabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // オリジナルのSVGサイズ
        let originalWidth: CGFloat = 378
        let originalHeight: CGFloat = 96

        // スケーリング係数（ビューのサイズに合わせて自動調整）
        let scaleX = rect.width / originalWidth
        let scaleY = rect.height / originalHeight

        path.move(to: CGPoint(x: 4 * scaleX, y: 40 * scaleY))
        path.addCurve(to: CGPoint(x: 44 * scaleX, y: 0 * scaleY),
                      control1: CGPoint(x: 4 * scaleX, y: 17.9086 * scaleY),
                      control2: CGPoint(x: 21.9086 * scaleX, y: 0 * scaleY))

        path.addLine(to: CGPoint(x: 118.765 * scaleX, y: 0))
        path.addCurve(to: CGPoint(x: 153.686 * scaleX, y: 21.1515 * scaleY),
                      control1: CGPoint(x: 133.366 * scaleX, y: 0),
                      control2: CGPoint(x: 146.86 * scaleX, y: 8.24431 * scaleY))

        path.addCurve(to: CGPoint(x: 223.138 * scaleX, y: 21.2241 * scaleY),
                      control1: CGPoint(x: 168.436 * scaleX, y: 49.0419 * scaleY),
                      control2: CGPoint(x: 208.764 * scaleX, y: 49.31 * scaleY))

        path.addCurve(to: CGPoint(x: 257.842 * scaleX, y: 0),
                      control1: CGPoint(x: 229.805 * scaleX, y: 8.19629 * scaleY),
                      control2: CGPoint(x: 243.207 * scaleX, y: 0))

        path.addLine(to: CGPoint(x: 334 * scaleX, y: 0))
        path.addCurve(to: CGPoint(x: 374 * scaleX, y: 40 * scaleY),
                      control1: CGPoint(x: 356.091 * scaleX, y: 0),
                      control2: CGPoint(x: 374 * scaleX, y: 17.9086 * scaleY))

        path.addLine(to: CGPoint(x: 374 * scaleX, y: 47.9263 * scaleY))
        path.addCurve(to: CGPoint(x: 334 * scaleX, y: 87.9263 * scaleY),
                      control1: CGPoint(x: 374 * scaleX, y: 70.0177 * scaleY),
                      control2: CGPoint(x: 356.091 * scaleX, y: 87.9263 * scaleY))

        path.addLine(to: CGPoint(x: 44 * scaleX, y: 87.9263 * scaleY))
        path.addCurve(to: CGPoint(x: 4 * scaleX, y: 47.9263 * scaleY),
                      control1: CGPoint(x: 21.9086 * scaleX, y: 87.9263 * scaleY),
                      control2: CGPoint(x: 4 * scaleX, y: 70.0177 * scaleY))

        path.addLine(to: CGPoint(x: 4 * scaleX, y: 40 * scaleY))
        path.closeSubpath()

        return path
    }
}
