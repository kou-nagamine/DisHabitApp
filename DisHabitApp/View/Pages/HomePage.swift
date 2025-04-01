import Foundation
import SwiftUI

struct HomePage: View {
    /// Manages the selected date (currentDate) and the weekdays of the current week (week)
    @State private var currentDate: Date = .init()
    
    ///
    @State private var path: [QuestBoardNavigation] = []
    @Binding var showTabBar: Bool
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                /// Header
                VStack(spacing: 0) {
                    HStack (spacing: 0){
                        Text(currentDate.format("y/M/d"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 10)
                    
                    /// Week Day Selector
                    WeekDaySelector()
                }
                QuestBoardView(showTabBar: $showTabBar, path: $path) // 仮
            }
            ///
            .navigationDestination(for: QuestBoardNavigation.self) { value in
                switch value {
                case .questDetails(let questSlot):
                    QuestDetailsPage(questSlot: questSlot, path: $path)
                }
            }
            .onChange(of: path) {
                if path.isEmpty {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showTabBar = true
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
