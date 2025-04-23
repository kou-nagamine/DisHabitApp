import Foundation
import SwiftUI

struct WeekDaySelector: View {
    @Binding var selectedDate: Date
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    /// add code
    @State private var createWeek: Bool = false
    
    var body: some View {
        HeaderView()
            .onAppear(perform: {
                if weekSlider.isEmpty {
                    /// get one week date
                    let currentWeek: [Date.WeekDay] = Date().fetchWeek()
                    
                    if let firstDate = currentWeek.first?.date {
                        weekSlider.append(firstDate.createPreviousWeek())
                    }
                    
                    weekSlider.append(currentWeek)
                    
                    if let lastDate = currentWeek.last?.date {
                        weekSlider.append(lastDate.createNextWeek())
                    }
                }
            })
        ///
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            /// weekly select slider
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            ///
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 80)
            
        }
        .padding(.horizontal,15)
        .background(.white)
        /// `of:` tells which value to track (currentWeekIndex).
        /// `initial: false` means don't trigger on the initial load, only when the value actually changes.
        .onChange(of: currentWeekIndex, initial: false) { _, newValue in
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
    }
    
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 0){
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
                .foregroundStyle(isSameDate(day.date, selectedDate) ? .white : .gray)
                .background(content: {
                    if isSameDate(day.date, selectedDate) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue.gradient)
                    }
                })
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .fill(.gray.gradient)
                }
                .frame(maxWidth: .infinity)
                .contentShape(.rect)
                .onTapGesture {
                    selectedDate = day.date
                }
                
            }
        }
        /// add code
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }
    
    func paginateWeek() {
        /// In Swift, accessing an out-of-bounds index causes a crash.
        /// This if statement prevents invalid access.
        if weekSlider.indices.contains(currentWeekIndex) {
            /// Safely unwrap the first date from the list and check if we're on the first page at the same time.
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == 2 {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = 1
            }
        }
    }
    
}

#Preview {
    ContentView()
}
