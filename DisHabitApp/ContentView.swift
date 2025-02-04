import SwiftUI

struct ContentView: View {
    
    @Namespace var testNamespace
    
    var body: some View {
        HomePageView()
    }
}

#Preview {
    ContentView()
}
