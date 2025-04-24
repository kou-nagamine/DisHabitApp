import SwiftUI

struct ContentView: View {
    ///Controls which tab is currently active in the TabBar
    @State private var activeTab: TabItem = .home
    
    ///Manages the visibility of the TabBar during navigation
    @State private var showTabBar: Bool = true

    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var router = Router.shared
    
    var body: some View {
        NavigationStack(path: $router.detailsNavigationPath) {
            ZStack(alignment: .bottom) {
                // iOS18~
                if #available(iOS 18, *) {
                    TabView(selection: $activeTab) {
                        Tab(value: TabItem.home) {
                            VStack {
                                HomePage(
                                    showTabBar: $showTabBar)
                            }
                            .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        Tab(value: TabItem.task) {
                            TargetPage()
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                    }
                    // ~iOS17
                } else {
                    TabView(selection: $activeTab) {
                        VStack {
                            HomePage(showTabBar: $showTabBar)
                            TabBar(activeTab: $activeTab)
                        }
                        .tag(TabItem.home)
                        .toolbar(.hidden, for: .tabBar)
                        TargetPage()
                            .tag(TabItem.task)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
                /// Custom TabBar
                TabBar(activeTab: $activeTab)
                    .opacity(showTabBar ? 1 : 0)
                    .offset(y: showTabBar ? 0 : 100) /// 100pt = TabBar(height:95pt) + margin(5pt)
                    .animation(.easeInOut(duration: 0.3), value: showTabBar)
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
