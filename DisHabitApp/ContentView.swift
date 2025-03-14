import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = QuestBoardViewModel(appDataService: AppDataService()) // 仮
    var body: some View {
        VStack(spacing: 10) {
            HomePageView(vm: vm) // 仮
            
        }
        
    }
}

#Preview {
    ContentView()
}
