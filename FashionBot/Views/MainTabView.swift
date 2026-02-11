import SwiftUI

struct MainTabView: View {
    enum Tab {
        case wardrobe
        case outfits
        case profile
    }

    @State private var selectedTab: Tab = .wardrobe

    var body: some View {
        TabView(selection: $selectedTab) {
            WardrobeView()
                .tag(Tab.wardrobe)
                .tabItem {
                    Label("Wardrobe", systemImage: "tshirt.fill")
                }

            OutfitsView()
                .tag(Tab.outfits)
                .tabItem {
                    Label("Outfits", systemImage: "sparkles")
                }

            ProfileView()
                .tag(Tab.profile)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tint(.accentColor)
    }
}

#Preview {
    MainTabView()
}
