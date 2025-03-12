import Foundation
import SwiftUI

struct AcceptedQuestCard: View {
    @ObservedObject var vm: QuestBoardViewModel
    var acceptedQuest: AcceptedQuest
    
    var body: some View {
        Text("Accepted Quest Card")
    }
}
