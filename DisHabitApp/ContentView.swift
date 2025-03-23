import SwiftUI

struct ContentView: View {
    @State private var activeTab: TabItem = .home
    @ObservedObject var vm = QuestBoardViewModel(appDataService: AppDataService()) // 仮
    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18, *) {
                TabView(selection: $activeTab) {
                    Tab(value: TabItem.home) {
                        HomePage(vm: vm)
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    Tab(value: TabItem.task) {
                        TaskPage()
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                }
            } else {
                TabView(selection: $activeTab) {
                    HomePage(vm: vm)
                        .tag(TabItem.home)
                        .toolbar(.hidden, for: .tabBar)
                    TaskPage()
                        .tag(TabItem.task)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
            TabBar(activeTab: $activeTab)
        }
    }
}

#Preview {
    ContentView()
}
