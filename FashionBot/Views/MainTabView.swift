import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            WardrobeView()
                .tabItem {
                    Label("Wardrobe", systemImage: "tshirt.fill")
                }

            OutfitsView()
                .tabItem {
                    Label("Outfits", systemImage: "sparkles")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
