//
//  LoginView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/6.
//

//
//  ContentView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/6.
//

import SwiftUI

        struct LoginView: View {
            @State private var email = ""
            @State private var password = ""
            var body: some View {
                ZStack{
                    VStack(spacing : 20){
                        //Welcome char that line
//                        Image(.welcome)
//                            .resizable()
//                            .scaledToFit()
                        
                        
                        TextField("Email" , text:$email)
                            .textFieldStyle(.plain)
                            .padding()
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(.plain)
                            .padding()

                        
                        
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
                        }label: {
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
                        }label:{
                        Text("Not have account? Register")
                            .bold()
                            .foregroundColor(.black)
                        }
                    .padding(.top)
                        
                    }
                }
                .ignoresSafeArea()
            }
        }

        #Preview {
            LoginView()
        }
    
#Preview {
    ContentView()
}
