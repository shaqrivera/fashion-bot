import SwiftUI

struct WardrobeView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No Clothing Items",
                systemImage: "tshirt.fill",
                description: Text("Add items to your wardrobe to get started.")
            )
            .navigationTitle("Wardrobe")
        }
    }
}

#Preview {
    WardrobeView()
        .modelContainer(try! ModelContainerFactory.createPreview())
}
