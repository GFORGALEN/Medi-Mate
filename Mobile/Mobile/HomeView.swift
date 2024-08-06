//
//  HomeView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/6.
//

import SwiftUI

struct HomeView: View {
    @State private var text: String = ""

    var body: some View {
        VStack{
                Text("Medimate")
                .font(.largeTitle)
                .bold()

        HStack {
            TextField("Type something...", text: $text)
            
            Button(action: {
                // Action for the camera button
            }) {
                Image(.cameraRetroSolid)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            }
            .background(Color.white)
            .cornerRadius(10)
            
        }
        .padding()
        .overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 4)
                        )
        .padding(.bottom, 200)
        .padding()

    }
}
}


#Preview {
    HomeView()
}
