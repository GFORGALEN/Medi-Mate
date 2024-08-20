//
//  CustomTabBar.swift
//  Mobile
//
//  Created by Jabin on 2024/8/20.
//

import SwiftUI
import AnimatedTabBar

class TabBarManager: ObservableObject {
    @Published var selectedIndex = 0
}

struct CustomTabBar: View {
    @EnvironmentObject var tabBarManager: TabBarManager
    let icons = ["house", "storefront", "map", "person.crop.circle"]
    
    var body: some View {
            HStack {
                //Spacer(minLength: 20)
                AnimatedTabBar(selectedIndex: $tabBarManager.selectedIndex, views: icons.indices.map { index in
                    wiggleButtonAt(index)
                })
                //.barColor(Color("bar"))
                //.cornerRadius(30)
                .barColor(Color.white.opacity(0.9))
                .selectedColor(.black)
                .unselectedColor(.gray)
                .ballColor(Color("bar"))
                .verticalPadding(30)
                .ballTrajectory(.parabolic)
                .ballAnimation(.easeOut(duration: 0.4))
                //Spacer(minLength: 20)
            }
            //.padding(.bottom, 20)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            .transition(.move(edge: .bottom))
        
    }
    
    private func wiggleButtonAt(_ index: Int) -> some View {
        WiggleButton(image: Image(systemName: icons[index]), maskImage: Image(systemName: "\(icons[index]).fill"), isSelected: index == tabBarManager.selectedIndex)
            .scaleEffect(1.5)
            .onTapGesture {
                tabBarManager.selectedIndex = index
            }
    }
}
