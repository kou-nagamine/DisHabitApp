import Foundation
import SwiftUI

struct WeekDaySelector: View {
    
    @State private var currentDate: Date = .init()
    @State private var week: [Date.WeekDay] = []
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(week){ day in
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text(day.date.format("E"))
                            .font(.callout)
                            .fontWeight(.medium)
                            .textScale(.secondary)
                            .padding(.top, 5)
                        Text(day.date.format("dd"))
                            .font(.callout)
                            .fontWeight(.bold)
                            .textScale(.secondary)
                            .frame(width: 40, height: 35)
                    }
                    .foregroundStyle(Date().isSameDate(day.date, currentDate) ? .white : .gray)
                    .background(content: {
                        if Date().isSameDate(day.date, currentDate) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.blue.gradient)
                        }
                    })
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 2)
                            .fill(.gray.gradient)
                    }
                    .mask {
                        RoundedRectangle(cornerRadius: 8)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.horizontal, 15)
        .padding(.top, 5)
        .padding(.bottom, 15)
        .onAppear {
            week = Date().fetchWeek()
        }
    }
}
