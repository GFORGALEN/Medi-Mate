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
struct DetailView: View {
    let medication: Medication
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("medication.name")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    DetailRow(title: "描述", content: medication.description)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
            }
            .padding()
        }
        //.background(Color(UIColor.systemGroupedBackground))
    }
}



struct MedicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(medication: Medication(
            image: .image,
            description: "ok"
            )
        )
    }
}
