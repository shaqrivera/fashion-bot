import PhotosUI
import SwiftData
import SwiftUI

struct AddClothingItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = AddClothingItemViewModel()
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showingCamera = false

    var body: some View {
        NavigationStack {
            Form {
                imageSection
                detailsSection
                seasonsSection
            }
            .navigationTitle("Add Clothing Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save(context: modelContext)
                        dismiss()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                if let newItem {
                    Task {
                        await viewModel.loadImage(from: newItem)
                    }
                }
            }
            .fullScreenCover(isPresented: $showingCamera) {
                CameraPicker(image: $viewModel.selectedImage)
                    .ignoresSafeArea()
            }
        }
    }

    // MARK: - Sections

    private var imageSection: some View {
        Section {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 250)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ContentUnavailableView(
                    "No Photo",
                    systemImage: "photo.on.rectangle",
                    description: Text("Add a photo of your clothing item.")
                )
                .frame(minHeight: 200)
            }

            HStack {
                PhotosPicker(
                    selection: $selectedPhotoItem,
                    matching: .images
                ) {
                    Label("Photo Library", systemImage: "photo.on.rectangle")
                }

                if viewModel.isCameraAvailable {
                    Spacer()
                    Button {
                        showingCamera = true
                    } label: {
                        Label("Camera", systemImage: "camera")
                    }
                }
            }
        }
    }

    private var detailsSection: some View {
        Section("Details") {
            TextField("Name", text: $viewModel.name)
            Picker("Category", selection: $viewModel.category) {
                ForEach(ClothingCategory.allCases, id: \.self) { category in
                    Text(category.rawValue.capitalized).tag(category)
                }
            }
            TextField("Color", text: $viewModel.color)
        }
    }

    private var seasonsSection: some View {
        Section("Seasons") {
            ForEach(Season.allCases, id: \.self) { (season: Season) in
                Button {
                    toggleSeason(season)
                } label: {
                    HStack {
                        Text(season.rawValue.capitalized)
                            .foregroundStyle(.primary)
                        Spacer()
                        if viewModel.seasonTags.contains(season) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func toggleSeason(_ season: Season) {
        if viewModel.seasonTags.contains(season) {
            viewModel.seasonTags.remove(season)
        } else {
            viewModel.seasonTags.insert(season)
        }
    }
}

#Preview {
    AddClothingItemView()
        .modelContainer(try! ModelContainerFactory.createPreview())
}
