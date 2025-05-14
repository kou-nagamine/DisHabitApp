import Foundation
import SwiftUI
import SwiftData

struct HomePage: View {
    @Environment(\.modelContext) private var modelContext

    
    /// Manages the selected date (currentDate) and the weekdays of the current week (week)
    @State private var currentDate: Date = .init()
    
    @Binding var showTabBar: Bool
    
    @State var selectedDate: Date = Date() // TODO: タブ切り替えした時に保持される？上位から与えることを考慮する
    
    @StateObject private var router = Router.shared
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 0) {
                /// Header
                VStack(spacing: 0) {
                    HStack (spacing: 0){
                        Text(currentDate.format("y/M/d"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        /// 設定項目がないためTestFlightでは必要ない
//                        Image(systemName: "gearshape")
//                            .resizable()
//                            .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 10)
                    
                    /// Week Day Selector
                    WeekDaySelector(selectedDate: $selectedDate)
                }
                QuestBoardView(selectedDate: $selectedDate, showTabBar: $showTabBar) // 仮
                
            }
            .onChange(of: Router.shared.path) {
                if Router.shared.path.isEmpty {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showTabBar = true
                    }
                }
            }
            .navigationDestination(for: QuestSlotManager.self) { manager in
                QuestDetailsPage(manager: manager)
            }
        }
    }
}


#Preview {
    ContentView()
}
