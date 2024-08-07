//
//  InitialView.swift
//  Mobile
//
//  Created by Lykheang Taing on 06/08/2024.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

struct InitialView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    
    
    var body: some View {
        VStack{
            if userLoggedIn{
                ContentView()
            } else {
                ContentView()
            }
            
            
        }.onAppear{
            
            Auth.auth().addStateDidChangeListener{auth, user in
            
                if (user != nil) {
                    
                    userLoggedIn = true
                } else{
                    userLoggedIn = false
                }
            }
        }
    }
}


