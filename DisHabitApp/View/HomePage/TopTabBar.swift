import Foundation
import SwiftUI

struct TopTabBarView: View {
    @Environment(\.colorScheme) private var scheme
    @Binding var selectedTab: ScrollableTabItem?
    @Binding var tabProgress: CGFloat
    var body: some View {
        HStack(spacing: 0) {
            ForEach(ScrollableTabItem.allCases, id:\.rawValue) { tab in
                Text(tab.rawValue)
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedTab = tab
                        }
                    }
            }
        }
        .tabMask(tabProgress)
        /// Scrollable Actibe Tab Indicator
        .background {
            GeometryReader {
                let size = $0.size
                let capusleWidth: CGFloat = size.width / CGFloat(ScrollableTabItem.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .blue : .black)
                    .padding(5)
                    .frame(width: capusleWidth)
                    .offset(x: tabProgress * (size.width - capusleWidth))
            }
        }
        .background(.white, in: .capsule)
        .overlay(
            Capsule()
                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
        )
        .padding(.horizontal, 25)
        .padding(.bottom, 20)
        
    }
}

#Preview {
    HomePageViewBkp()
}
