import Foundation
import SwiftUI
import SwiftData

struct HomePage: View {
    @Environment(\.modelContext) private var modelContext

    
    /// Manages the selected date (currentDate) and the weekdays of the current week (week)
    @State private var currentDate: Date = .init()
    
    ///
    @State private var path: [QuestBoardNavigation] = []
    @Binding var showTabBar: Bool
    
    @State var selectedDate: Date = Date() // TODO: タブ切り替えした時に保持される？上位から与えることを考慮する
    
    
    var body: some View {
//        NavigationStack(path: $path) {
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
                    WeekDaySelector(selectedDate: $selectedDate)
                }
                QuestBoardView(selectedDate: $selectedDate, showTabBar: $showTabBar, path: $path) // 仮
//            }
            ///
//            .navigationDestination(for: QuestBoardNavigation.self) { value in
//                switch value {
//                case .questDetails(let questSlotManager):
//                    QuestDetailsPage(questSlotmanager: questSlotManager, path: $path)
//                }
//            }
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
