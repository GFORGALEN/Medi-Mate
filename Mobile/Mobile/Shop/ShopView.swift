//
//  ShopView.swift
//  Mobile
//
//  Created by Lykheang Taing on 14/08/2024.
//


import SwiftUI

struct ShopView: View {
    @ObservedObject var authViewModel: AuthenticationView
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var showLoginView = false
    
    var body: some View {
        NavigationView {
            Group {
                if authViewModel.isLoginSuccessed {
                    shopContent
                } else {
                    loginPrompt
                }
            }
            .navigationTitle("Shop")
            .sheet(isPresented: $showLoginView) {
                LoginView(authViewModel: authViewModel)
            }
        }
    }
    
    private var shopContent: some View {
        Text("Welcome to the Shop!")
    }
    
    private var loginPrompt: some View {
        VStack {
            Text("Please log in to view the shop")
                .font(.headline)
                .padding()
            
            Button("Login") {
                showLoginView = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ShopView(authViewModel: AuthenticationView())
}

