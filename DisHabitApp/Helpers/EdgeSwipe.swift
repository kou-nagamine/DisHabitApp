// 参考：https://qiita.com/seita-sa-n/items/5c847be63fd4748b58e3

import SwiftUI

struct EdgeSwipe: ViewModifier {
    @Environment(\.dismiss) var dismiss

    // 条件式から以下を外すと画面全体でスワイプできるようになる
//    private let edgeWidth: Double = 30
    // スワイプ必要量, 画面全体がスワイプ可能なため自然とジェスチャーの大きくなるため、値も大きめに設定
    private let baseDragWidth: Double = 100
    
    func body(content: Content) -> some View {
        content
            .gesture (
                DragGesture().onChanged { value in
                    if /*value.startLocation.x < edgeWidth && */ value.translation.width > baseDragWidth {
                        dismiss()
                    }
                }
            )
    }
}

extension View {
    
    func edgeSwipe() -> some View {
        self.modifier(EdgeSwipe())
    }
}
