import SwiftUI

struct PieChart: View {
    
    var progress: CGFloat
    var barThick: CGFloat
    var graphSize: CGFloat
    var fontSize: CGFloat
    var percentSize: Font
    var progressBackgroundColor: Color
    
    var body: some View {
        ZStack {
            if progress == 0 {
                // background gray Circle
                Circle()
                    .stroke(lineWidth: barThick)
                    .frame(width: graphSize, height: graphSize)
                    .foregroundStyle(progressBackgroundColor)
            } else {
                // background gray Circle
                Circle()
                    .stroke(lineWidth: barThick)
                    .frame(width: graphSize, height: graphSize)
                    .foregroundStyle(progressBackgroundColor)
                //
                Circle()
                    .trim(from: 0, to: CGFloat(progress) / CGFloat(1)) // 円グラフの進捗管理
                    .stroke(style: StrokeStyle(lineWidth: barThick, lineCap: .round, lineJoin: .round)) // 両端・結合部を丸く
                    .frame(width: graphSize, height: graphSize)
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue, .cyan]), startPoint: .top, endPoint: .bottom)) // 上から下に紫 → ピンクにグラデーション
                    .rotationEffect(.degrees(-90)) // .trimはスタート地点が3時なので、90度もどす
            }
            // Percentage text
            HStack(alignment: .bottom, spacing: 0) {
                Text("\(Int((CGFloat(progress) / CGFloat(1)) * 100))\(Text("%").font(percentSize).fontWeight(.bold))")
                    .font(.system(size: fontSize))
                    .monospacedDigit()
                    .padding(.leading, 7)
            }
        }
    }
}
