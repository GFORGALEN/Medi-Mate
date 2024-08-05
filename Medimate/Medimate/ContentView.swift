//
//  ContentView.swift
//  Medimate
//
//  Created by Jabin on 2024/8/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            
            Login()
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Home",
                    systemImage: "house")}
            
            Text("bag")
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem { Label("shop",systemImage: "bag.fill") }
            
            Text("Cart")
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("cart",
                    systemImage: "cart.fill")}
           
            Text("Account")
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                Label("Account",
                systemImage: "person.crop.circle")}
            
        }
    }
}

#Preview {
    ContentView()
}
