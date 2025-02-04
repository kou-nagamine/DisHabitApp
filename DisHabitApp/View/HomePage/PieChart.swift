import SwiftUI

struct PieChart: View {
    @EnvironmentObject var dateModel : DateModel
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 7)
                .frame(width: 60, height: 60)
                .foregroundStyle(.gray.opacity(0.5))
            Circle()
                .trim(from: 0, to: CGFloat(dateModel.selection.count) / CGFloat(dateModel.allSelectionNumber))
                .stroke(style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))
                .frame(width: 60, height: 60)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .pink]), startPoint: .top, endPoint: .bottom))
                .rotationEffect(.degrees(-90))
            // Percentage text
            HStack(alignment: .bottom, spacing: 0) {
                Text("\(Int((CGFloat(dateModel.selection.count) / CGFloat(dateModel.allSelectionNumber)) * 100))\(Text("%").font(.caption2))")
                    .font(.title3)
                    .monospacedDigit()
                    .padding(.leading, 7)
            }
        }
    }
}

#Preview {
    PieChart()
        .environmentObject(DateModel())
}
