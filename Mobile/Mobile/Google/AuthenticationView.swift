//
//  AuthenticationView.swift
//  Mobile
//
//  Created by Lykheang Taing on 06/08/2024.
//

import Foundation
import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth

class AuthenticationView: ObservableObject{
    
    @Published var isLoginSuccessed = false
    @Published var currentUser: User?

       init() {
           self.currentUser = Auth.auth().currentUser
       }

    
    func signInWithGoogle(){
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let user = user?.user,
                let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            print(accessToken)
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            print (credential)
            
            Auth.auth().signIn(with: credential) { res, error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                self.currentUser = res?.user
                self.isLoginSuccessed = true
            }
        }
        
    }
    
    func logout() async throws {
            GIDSignIn.sharedInstance.signOut()
            try Auth.auth().signOut()
            isLoginSuccessed = false
            currentUser = nil
        }
    }
