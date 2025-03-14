import Foundation
import SwiftUI

struct HomePageView: View {
    @ObservedObject var vm: QuestBoardViewModel
    var body: some View {
        VStack {
            Text("HomePageView")
            // Header
            VStack {
                
            }
            
            QuestBoardView(vm: vm) // 仮
        }
    }
}

#Preview {
    HomePageView(vm: QuestBoardViewModel(appDataService: AppDataService()))
}
