//
//  CartView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/20.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Cart")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink(destination: SubView()) {
                    Text("Click to subpage")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("cart")
        }
    }
}

struct SubView: View {
    var body: some View {
        VStack {
            Text("subpage")
                .font(.title)
        }
        .navigationTitle("subpage")
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
