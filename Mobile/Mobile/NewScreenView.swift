//
//  NewScreenView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/12.
//
import SwiftUI


struct NewScreenView: View {
    var body: some View {
        VStack {
            Text("这是新界面")
                .font(.largeTitle)
            
            Text("这里可以添加更多内容")
                .padding()
        }
        .navigationTitle("新界面")
    }
}

