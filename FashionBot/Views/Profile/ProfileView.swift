import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Profile",
                systemImage: "person.fill",
                description: Text("Set your style preferences and manage your account.")
            )
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
