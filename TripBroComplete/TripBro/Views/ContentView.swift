import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TripListView()
                .tabItem {
                    Label("Trips", systemImage: "suitcase.fill")
                }

            Text("Discover")
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }

            Text("Stats")
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }

            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.orange)
    }
}

#Preview {
    ContentView()
}
