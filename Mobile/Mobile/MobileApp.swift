//
//  MobileApp.swift
//  Mobile
//
//  Created by Jabin on 2024/8/6.
//

import SwiftUI


struct MobileApp: App {
    @AppStorage("isOlderMode") private var isOlderMode = false
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.fontSizeMultiplier, isOlderMode ? 1.25 : 1.0)
        }
    }
}
