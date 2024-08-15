//
//  DetailView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/12.
//

import SwiftUI


// 详情行组件
struct DetailRow: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(content)
                .font(.body)
        }
    }
}

// 药品详情视图
struct ImageDetailView: View {
    let medication: Medication
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Image(uiImage: medication.image ?? UIImage(systemName: "photo")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("\(medication.description?.name ?? "Non")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    DetailRow(title: "Description", content: medication.description?.description ?? "Non")
                    DetailRow(title: "CommonUse", content: medication.description?.commonUse ?? "Non")
                    DetailRow(title: "SideEffects", content: medication.description?.sideEffects ?? "Non")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
            }
            .padding()
        }
    }
}

