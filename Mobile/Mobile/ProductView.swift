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
struct MedicationDetailView: View {
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
                    Text(medication.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    DetailRow(title: "描述", content: medication.description)
                    DetailRow(title: "用法用量", content: medication.dosage)
                    DetailRow(title: "可能的副作用", content: medication.sideEffects)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

// 预览提供者
struct MedicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationDetailView(medication: Medication(
            name: "阿司匹林",
            description: "阿司匹林是一种常用的非甾体抗炎药，具有止痛、退烧、抗炎和抗血小板聚集的作用。",
            dosage: "成人常用剂量为每次0.3~1.0g，每4~6小时1次，日剂量不超过4g。",
            sideEffects: "常见副作用包括胃肠道不适、轻微出血。长期大量使用可能会导致胃溃疡或肾功能损害。对阿司匹林过敏的人不应使用。",
            imageName: "aspirin"
        ))
    }
}
