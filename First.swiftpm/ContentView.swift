
import SwiftUI

@main
struct ContentView: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    @State private var isBlack = true
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .font(.title)
                .foregroundColor(isBlack ? .black : .white)
            
            Button("Toggle Color") {
                isBlack.toggle()
            }
            .padding()
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
