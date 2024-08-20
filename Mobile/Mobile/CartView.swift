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
                Text("主页面")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink(destination: SubView()) {
                    Text("点击进入子页面")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("主页")
        }
    }
}

struct SubView: View {
    var body: some View {
        VStack {
            Text("这是子页面")
                .font(.title)
        }
        .navigationTitle("子页面")
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
