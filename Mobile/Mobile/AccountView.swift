//
//  AccountView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/10.
//

import SwiftUI

struct AccountView: View {
    @ObservedObject var authViewModel: AuthenticationView

    var body: some View {
        VStack {
            Text("Welcome, \(authViewModel.currentUser?.email ?? "User")!")
            Button("Logout") {
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
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(authViewModel: AuthenticationView())
    }
}
