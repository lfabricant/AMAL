import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            DataView()
                .tabItem {
                    Label("Data", systemImage: "gauge.chart.lefthalf.righthalf")
                }

            TrendsView()
                .tabItem {
                    Label("Trends", systemImage: "waveform.path.ecg.rectangle")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
