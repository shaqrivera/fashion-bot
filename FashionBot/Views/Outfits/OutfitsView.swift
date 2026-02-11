import SwiftUI

struct OutfitsView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No Outfits Yet",
                systemImage: "sparkles",
                description: Text("Your AI-generated outfit suggestions will appear here.")
            )
            .navigationTitle("Outfits")
        }
    }
}

#Preview {
    OutfitsView()
        .modelContainer(try! ModelContainerFactory.createPreview())
}
