import SwiftUI

struct AccountView: View {
    @ObservedObject var authViewModel: AuthenticationView
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier

    @State private var showingEditProfile = false
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Profile").scalableFont(size: 14, weight: .semibold)) {
                    HStack {
                        if let profileImageURL = authViewModel.userPicURL {
                            AsyncImage(url: profileImageURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 50, height: 50)
                            }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(authViewModel.userName)
                                .scalableFont(size: 16, weight: .semibold)
                            Text(authViewModel.userEmail)
                                .scalableFont(size: 14)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Button("Edit Profile") {
                        showingEditProfile = true
                    }
                    .scalableFont(size: 16)
                }

                Section(header: Text("Preferences").scalableFont(size: 14, weight: .semibold)) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Label {
                            Text("Settings")
                                .scalableFont(size: 16)
                        } icon: {
                            Image(systemName: "gear")
                        }
                    }
                }

                Section {
                    Button("Logout", role: .destructive) {
                        Task {
                            do {
                                try await authViewModel.logout()
                            } catch {
                                print("Error logging out: \(error.localizedDescription)")
                            }
                        }
                    }
                    .scalableFont(size: 16)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Account")
            .scalableFont(size: 20, weight: .bold) // For the navigation title
            .sheet(isPresented: $showingEditProfile) {
                NavigationView {
                    Text("Edit Profile View")
                        .scalableFont(size: 16)
                        .navigationTitle("Edit Profile")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .sheet(isPresented: $showingSettings) {
                NavigationView {
                    Text("Settings View")
                        .scalableFont(size: 16)
                        .navigationTitle("Settings")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .environment(\.fontSizeMultiplier, fontSizeMultiplier)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(authViewModel: AuthenticationView())
    }
}
