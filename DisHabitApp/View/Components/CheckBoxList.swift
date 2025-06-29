import Foundation
import SwiftUI

struct CheckBoxList: View {
    
    var isSelected: Bool
    var taskName: String
    var isReadonly: Bool
    var isLabelOnly: Bool
    var checkedStyle: CheckedStyle
    var toggleAction: () -> Void
    
    func checkedBackgroundColor(checkedStyle: CheckedStyle) -> Color {
        switch checkedStyle {
        case .complete:
            return .gray
        case .select:
            return .blue
        }
    }
    
    var body: some View {
        VStack (spacing: 20){
            HStack(alignment: .center, spacing: 8) {
                /// checkbox
                if isLabelOnly {
                    Spacer()
                        .frame(width: 20, height: 20)
//                        .padding(.leading, 20) // あえてCheckBoxと異なるpaddingにする方が動きがあってUIがいい感じ？
                } else {
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
                }

                // text
                Text(taskName)
                    .font(.system(size: 20, weight: .medium))
                    .strikethrough(checkedStyle == .complete ? isSelected : false)
                    .bold(checkedStyle == .select ? isSelected : false)
                    .foregroundColor(isSelected ? .white : .black)
                    .padding(.leading, 10)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 65)
            .background(isSelected ? checkedBackgroundColor(checkedStyle: checkedStyle) : .white, in: RoundedRectangle(cornerRadius: 18))
            .shadow(color: .gray.opacity(0.2), radius: 2, x: 2, y: 2)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(lineWidth: 3)
                    .fill(.gray.gradient.opacity(0.2))
            }
            .padding(.horizontal, 30)
            .onTapGesture {
                if !isReadonly {
                    toggleAction()
                }
            }
        }
    }
}

public enum CheckedStyle: String, CaseIterable {
    case complete
    case select
}

#Preview {
    CheckBoxList(isSelected: false, taskName: "英単語5個", isReadonly: false, isLabelOnly: false, checkedStyle: .select, toggleAction: {})
}
