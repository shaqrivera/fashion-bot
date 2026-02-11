import SwiftData
import SwiftUI

struct WardrobeView: View {
    @State private var showingAddItem = false

    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No Clothing Items",
                systemImage: "tshirt.fill",
                description: Text("Add items to your wardrobe to get started.")
            )
            .navigationTitle("Wardrobe")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddItem = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add Clothing Item")
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddClothingItemView()
            }
        }
    }
}

#Preview {
    WardrobeView()
        .modelContainer(try! ModelContainerFactory.createPreview())
}
