import Foundation
import SwiftUI

final class DateModel: ObservableObject {
    @Published var selection: Set<Option> = []
    @Published var allSelectionNumber: Int = Option.allCases.count
}

struct MultiCheckBox: View {
    @Binding var selection: Set<Option>
    var options: [Option]
    
    var screenWidth: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.screen.bounds.width
    }
    
    var body: some View {
        VStack (spacing: 20){
            ForEach(options, id: \.self) { option in
                let isSelected = selection.contains(option)
                
                HStack(alignment: .center, spacing: 8) {
                    // checkbox
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(isSelected ? .green : .white)
                        .frame(width: 20, height: 20)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(isSelected ? .clear : .gray, lineWidth: 1)
                        }
                        .overlay {
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 12, weight: .bold))
                            }
                        }
                        .padding(.leading, 20)
                    // text
                    Text(option.name)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .strikethrough(isSelected)
                        .padding(.leading, 10)
                    Spacer()
                }
                .frame(width: screenWidth - 60, height: 60)
                .background(isSelected ? .gray : .white)
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                
                .onTapGesture {
                    if isSelected {
                        selection.remove(option)
                    } else {
                        selection.insert(option)
                    }
                }
            }
        }
        .safeAreaPadding(.bottom, 140)
    }
}

public enum Option: CaseIterable {
    
    case pop
    case classical
    case metal
    case rock
    
    var name: String {
        switch self {
        case .pop:
            return "Pop"
        case .classical:
            return "Classical"
        case .metal:
            return "Metal"
        case .rock:
            return "Rock"
        }
    }
}
