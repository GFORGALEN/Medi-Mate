import SwiftUI

struct AccountView: View {
    @ObservedObject var authViewModel: AuthenticationView

    @State private var showingEditProfile = false
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Profile")) {
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
                                .font(.headline)
                            Text(authViewModel.userEmail)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Button("Edit Profile") {
                        showingEditProfile = true
                    }
                }

//                Section(header: Text("Account")) {
//                    NavigationLink(destination: Text("Order History")) {
//                        Label("Order History", systemImage: "list.bullet")
//                    }
//                    NavigationLink(destination: Text("Payment Methods")) {
//                        Label("Payment Methods", systemImage: "creditcard")
//                    }
//                    NavigationLink(destination: Text("Address Book")) {
//                        Label("Address Book", systemImage: "book")
//                    }
//                }

                Section(header: Text("Preferences")) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Label("Settings", systemImage: "gear")
                    }
//                    Toggle("Notifications", isOn: .constant(true))
//                    Toggle("Dark Mode", isOn: .constant(false))
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
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Account")
            .sheet(isPresented: $showingEditProfile) {
                Text("Edit Profile View")
                    .navigationTitle("Edit Profile")
            }
            .sheet(isPresented: $showingSettings) {
                Text("Settings View")
                    .navigationTitle("Settings")
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(authViewModel: AuthenticationView())
    }
}
