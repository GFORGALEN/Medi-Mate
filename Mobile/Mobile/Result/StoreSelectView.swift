//
//  StoreSelectView.swift
//  Mobile
//
//  Created by Jabin on 2024/9/5.
//

import SwiftUI

struct StoreSelectionPopup: View {
    @Binding var isPresented: Bool
    @Binding var selectedStore: String?
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    
    let stores = ["NewMarket", "Manakua", "Mount Albert", "Albany", "CBD"]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack {
                Text("Select a Store")
                    .scalableFont(size: isOlderMode ? 24 : 20, weight: .bold)
                    .padding()
                
                    ForEach(stores, id: \.self) { store in
                        Button(action: {
                            selectedStore = store
                            isPresented = false
                            // 这里可以添加导航到新视图的逻辑
                        }) {
                            Text(store)
                                .scalableFont(size: isOlderMode ? 20 : 16)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .foregroundColor(.primary)
                                .cornerRadius(isOlderMode ? 12 : 8)
                        }
                        .padding(.horizontal)
                    }
                Button("Cancel") {
                    isPresented = false
                }
                .scalableFont(size: isOlderMode ? 18 : 14)
                .padding()
                .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(isOlderMode ? 20 : 15)
            .shadow(radius: 10)
            .padding(isOlderMode ? 30 : 20)
        }
    }
}


#Preview {
    struct PreviewWrapper: View {
        @State private var isPresented = true
        @State private var selectedStore: String?
        
        var body: some View {
            StoreSelectionPopup(isPresented: $isPresented, selectedStore: $selectedStore)
        }
    }
    
    return PreviewWrapper()
}
