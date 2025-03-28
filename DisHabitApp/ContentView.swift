import SwiftUI

struct ContentView: View {
    @State private var activeTab: TabItem = .home
    @State private var showTabBar: Bool = true
    
    @ObservedObject var vm = QuestBoardViewModel(appDataService: AppDataService()) // 仮
    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18, *) {
                TabView(selection: $activeTab) {
                    Tab(value: TabItem.home) {
                        VStack {
                            HomePage(vm: vm, showTabBar: $showTabBar)
                        }
                        .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    Tab(value: TabItem.task) {
                        TargetPage()
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                }
            } else {
                TabView(selection: $activeTab) {
                    VStack {
                        HomePage(vm: vm, showTabBar: $showTabBar)
                        TabBar(activeTab: $activeTab)
                    }
                    .tag(TabItem.home)
                    .toolbar(.hidden, for: .tabBar)
                    TargetPage()
                        .tag(TabItem.task)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
            if showTabBar {
                TabBar(activeTab: $activeTab)
            }
        }
    }
}

#Preview {
    ContentView()
}
