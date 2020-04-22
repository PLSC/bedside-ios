//
//  ContentView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/12/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import AWSMobileClient

struct LoginView: View {
        
    @State private var username = ""
    @State private var password = ""
    @State private var showForgotPassword = false
    @State private var showEmailCodeEnter = false
    
    let authUtil = AuthUtils()
    
    func signIn() {
        authUtil.signIn(userName: username, password: password) {
            result in
            switch result {
            case .signedIn:
                print("Cool, signed in")
                self.username = ""
                self.password = ""
            case .needsConfirmation:
                print("Show code screen")
                self.showEmailCodeEnter = true
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: HorizontalAlignment.center, spacing: 15) {
                Text("Bedside Procedures")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .padding([.top, .bottom], 20)
                    
                TextField("Username", text: self.$username)
                    .padding()
                    .keyboardType(.alphabet)
                    .autocapitalization(.none)

                SecureField("Password", text: self.$password)
                    .padding()
                    .cornerRadius(20)

                Button(action:{self.signIn()}) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                
                NavigationLink(destination: ForgotPasswordView(showSelf:$showForgotPassword), isActive:$showForgotPassword) {
                    Text("")
                }
                
                Button(action:{
                    self.showForgotPassword = true
                }) {
                    Text("Forgot Password")
                }
                
                NavigationLink(destination: EmailCodeView(showSelf: $showEmailCodeEnter, username: $username, confirmationCode: ""), isActive: $showEmailCodeEnter) {
                    Text("")
                }
                
                Spacer()
                
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let authUtil = UserLoginState()
        authUtil.isSignedIn = false
        return LoginView().environmentObject(authUtil)
    }
}
