//
//  TranceparentBlurView.swift
//  DisHabitApp
//
//  Created by 長峯 幸佑 on 2025/05/17.
//

import SwiftUI

struct DrawerConfig {
    var tint: Color
    var forground: Color
    var clipShape: AnyShape
    var animation: Animation
    
    fileprivate(set) var isPresented: Bool = false
    fileprivate(set) var hideSourceButton: Bool = false
    fileprivate(set) var sourceRect: CGRect = .zero
    
    init(tint: Color = .red, foreground: Color = .white, clipShape: AnyShape = .init(.capsule), animation: Animation = .snappy(duration: 0.35, extraBounce: 0)) {
        self.tint = tint
        self.forground = foreground
        self.clipShape = clipShape
        self.animation = animation
    }
}

struct DrawerButton: View {
    var title: String
    @Binding var config: DrawerConfig
    var body: some View {
        Button {
            config.hideSourceButton = true
            withAnimation(config.animation) {
                config.isPresented = true
            }
        } label: {
            Text(title)
                .fontWeight(.semibold)
                .foregroundStyle(config.forground)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(config.tint, in: config.clipShape)
        }
        .buttonStyle(SelectedButtonStyle())
        .opacity(config.hideSourceButton ? 0 : 1)
        .onGeometryChange(for: CGRect.self) {
            $0.frame(in: .global)
        } action: { newValue in
            config.sourceRect = newValue
        }
    }
    
}

/// カスタムアラート
extension View {
    @ViewBuilder
    func alertDrawer<Content: View>(
        config: Binding<DrawerConfig>,
        primaryTitle: String,
        secondaryTitle: String,
        onPrimaryClick: @escaping () -> Bool,
        onSecondaryClick: @escaping () -> Bool,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                GeometryReader { geometry in
                    let isPresented = config.wrappedValue.isPresented
                    
                    ZStack {
                        if isPresented {
                            Rectangle()
                                .fill(.black.opacity(0.5))
                                .transition(.opacity)
                                .onTapGesture {
                                    withAnimation(config.wrappedValue.animation) {
                                        config.wrappedValue.isPresented = false
                                    } completion: {
                                        config.wrappedValue.hideSourceButton = false
                                    }
                                }
                        }
                        
                        if config.wrappedValue.hideSourceButton {
                            AlertDrawerContent(
                                proxy: geometry,
                                primaryTitle: primaryTitle,
                                secondaryTitle: secondaryTitle,
                                onPrimaryClick: onPrimaryClick,
                                onSecondaryClick: onSecondaryClick,
                                config: config,
                                content: content
                            )
                            .transition(.identity)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                    }
                    .ignoresSafeArea()
                }
            }
    }
}

fileprivate struct AlertDrawerContent<Content: View>: View {
    var proxy: GeometryProxy
    var primaryTitle: String
    var secondaryTitle: String
    var onPrimaryClick: () -> Bool
    var onSecondaryClick: () -> Bool
    @Binding var config: DrawerConfig
    @ViewBuilder var content: Content
    var body: some View {
        let isPresented = config.isPresented
        let sourceRect = config.sourceRect
        let maxY = proxy.frame(in: .global).maxY
        let bottomPadding: CGFloat = 10
        
        VStack(spacing: 15) {
            content
                .overlay(alignment: .topTrailing) {
                    Button (action: dismissDrawer) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.primary, .gray.opacity(0.15))
                    }
                }
                .compositingGroup()
                .opacity(isPresented ? 1 : 0)
            
            HStack(spacing: 10) {
                GeometryReader { geometry in
                    Button {
                        if onPrimaryClick() {
                            dismissDrawer()
                        }
                    } label: {
                        Text(primaryTitle)
                            .fontWeight(.semibold)
                            .foregroundStyle(config.forground)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(config.tint, in: config.clipShape)
                    }
                    .frame(
                        width: isPresented ? nil : sourceRect.width,
                        height: isPresented ? nil : sourceRect.height
                    )
                    .offset(fixedLocation(geometry))
                }
                .frame(height: config.sourceRect.height)
                
                GeometryReader { geometry in
                    Button {
                        if onSecondaryClick() {
                            dismissDrawer()
                        }
                    } label: {
                        Text(secondaryTitle)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.ultraThinMaterial, in: config.clipShape)
                    }
                    .offset(fixedLocation(geometry))
                    .opacity(isPresented ? 1 : 0)
                }
                .frame(height: config.sourceRect.height)
                /// このビューをキャンセルボタンの上に配置する！
                .zIndex(1)
            }
            .buttonStyle(SelectedButtonStyle())
            .padding(.top, 10)
        }
        .padding([.horizontal, .top], 20)
        .padding(.bottom, 15)
        .frame(
            width: isPresented ? nil : sourceRect.width,
            height: isPresented ? nil : sourceRect.height,
            alignment: .top
        )
        .background(.background)
        .clipShape(.rect(cornerRadius: sourceRect.height / 2))
        ///
        .shadow(color: .black.opacity(isPresented ? 0.1 : 0), radius: 5, x: 5, y: 5)
        .shadow(color: .black.opacity(isPresented ? 0.1 : 0), radius: 5, x: -5, y: -5)
        .padding(.horizontal, isPresented ? 20 : 0)
        .visualEffect { content, proxy in
            content
                .offset(
                    x: isPresented ? 0 : sourceRect.minX,
                    y: (isPresented ? maxY - bottomPadding :sourceRect.maxY) - proxy.size.height
                )
        }
        .allowsHitTesting(config.hideSourceButton)
    }
    
    private func dismissDrawer() {
        withAnimation(config.animation, completionCriteria: .logicallyComplete) {
            config.isPresented = false
        } completion: {
            config.hideSourceButton = false
        }
    }
    
    private func fixedLocation(_ proxy: GeometryProxy) -> CGSize {
        let isPresented = config.isPresented
        let sourceRect = config.sourceRect
        
        return CGSize(
            width: isPresented ? 0 : (sourceRect.minX - proxy.frame(in: .global).minX),
            height: isPresented ? 0 : (sourceRect.minY - proxy.frame(in: .global).minY)
        )
    }
}

/// buttonの独自アニメーション
fileprivate struct SelectedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.linear(duration: 0.1), value: configuration.isPressed)
    }
}
