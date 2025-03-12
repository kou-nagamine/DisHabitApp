import Foundation
import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// get initialize scroll view
extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX) // OffsetKey value change new minX
                        .onPreferenceChange(OffsetKey.self, perform: completion) // do perform
                }
            }
    }
    
    @ViewBuilder
    func tabMask(_ tabProgress: CGFloat) -> some View {
        ZStack {
            self
                .foregroundStyle(.black)
            
            self
                .foregroundStyle(.white)
                .mask {
                    GeometryReader {
                        let size = $0.size
                        let capusleWidth: CGFloat = size.width / CGFloat(ScrollableTabItem.allCases.count)
                        
                        Capsule()
                            .frame(width: capusleWidth)
                            .offset(x: tabProgress * (size.width - capusleWidth))
                    }
                }
        }
    }
}

#Preview {
    HomePageViewBkp()
}
