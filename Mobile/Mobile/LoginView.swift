//
//  LoginView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/6.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State var showRegister = false //registerpage
    
    
    var body: some View {
        ZStack{
            VStack(spacing: 20){
                
                //Welcome
                Text("Welcome to Medimate")
                    .font(.title)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                
                Button{
                    //sign up
                } label: {
                    Text("Sign Up")
                        .bold()
                        .padding()
                        .frame(width: 200, height: 40)
                        .foregroundColor(.black)
                        .background(.blue)
                        .cornerRadius(10)
                        .shadow(radius: 1, y: 5)
                }
                
                Button{
                    //login
                } label: {
                    HStack {
                        //                                Image(.googleBrandsSolid)
                        //                                    .resizable()
                        //                                    .aspectRatio(contentMode: .fit)
                        //                                    .frame(width: 24, height: 24)
                        Text("Sign in with Google")
                            .foregroundColor(.black)
                            .bold()
                    }
                    .frame(width: 250, height: 50)
                    .background(Color.white)
                    .cornerRadius(8)
                }
                .padding()
                .shadow(radius: 2)
                
                
                Button{
                    //register                    
                    showRegister.toggle()
                }label:{
                    Text("Not have account? Register")
                        .bold()
                        .foregroundColor(.black)
                }
                .padding(.top)
                
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showRegister){
            RegisterView()
        }
    }
}





#Preview {
            LoginView()
        }
    
