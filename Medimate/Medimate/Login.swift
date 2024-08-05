//
//  Login.swift
//  Medimate
//
//  Created by Lykheang Taing on 05/08/2024.
//

//
//  ContentView.swift
//  Login Authentication
//
//  Created by Lykheang Taing on 05/08/2024.
//

import SwiftUI

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        ZStack{
            Color.black
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors:[.gray], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width:1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y:-350)
//            background effect
            
            VStack(spacing : 20){
                Text ("Welcome to MediMate")
                    .foregroundColor(.white)
                    .font(.system(size:25, weight: .bold,design: .rounded))
                    .offset(x:-10, y:-100)
                //                Welcome char that line
                
                
                TextField("Email" , text:$email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    
                
                Rectangle().frame(width:350,height:1)
                    .foregroundColor(.white)
                
                SecureField("Password", text: $password).foregroundColor(.white)
                    .textFieldStyle(.plain)
                    
                Rectangle().frame(width:350,height:1)
                    .foregroundColor(.white)
                
                
                
                
                Button {
                    // Action for Sign Up
                } label: {
                    Text("Sign Up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white)
                        .background(LinearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                        .cornerRadius(10)
                }
                .padding(.top)
                .offset(y:50)
                
                Button(action: {
                        // Insert your Google login authentication logic here
                    }) {
                        HStack {
                            Image(.googleBrandsSolid)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
//                            not yet put image
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
                    .offset(y:50)
                
                Button{
//                    login
                }
            label:{
                Text("Already have an account? Login")
                    .bold()
                    .foregroundColor(.black)
                
            }
            .padding(.top)
            .offset(y:110)

            
            
                
                
            }.frame(width:350)
            
            
            
            

        }.ignoresSafeArea()
    }
}

#Preview {
    Login()
}

//extension View {
//    func placeholder<Content: View>(
//        when shouldShow: Bool,
//        alignment: Alignment = .leading,
//        @ViewBuilder placeholder: () -> Content) -> some View {
//
//        ZStack(alignment: alignment) {
//            placeholder().opacity(shouldShow ? 1 : 0)
//            self
//        }
//    }
//}
