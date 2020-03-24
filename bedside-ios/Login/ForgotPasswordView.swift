//
//  ForgotPasswordView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/2/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI


class ForgotPasswordViewModel : ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var codeSent = false
    @Published var code = ""
    @Published var codeSentMessage = ""
    @Published var success = false
    
    let authUtil : AuthUtils
    
    init(authUtil: AuthUtils = AuthUtils()) {
        self.authUtil = authUtil
    }
    
    func sendCode() {
        authUtil.sendAuthCode(username: username) {
            sent, message in
            DispatchQueue.main.async {
                self.codeSent = sent
                self.codeSentMessage = message
            }
       }
    }
       
    func confirmForgotPassword(action: @escaping ()->()) {
        authUtil.confirmForgotPassword(username: username, newPassword: password, code: code) {
            success, message in
            DispatchQueue.main.async {
                self.codeSentMessage = message
                self.success = true
                action()
            }
        }
   }
}

struct ForgotPasswordView: View {
    
    @EnvironmentObject var authUtil : LoggedInState
    @ObservedObject var viewModel = ForgotPasswordViewModel()
    @Binding var showSelf : Bool
    
    var body: some View {
        
        VStack {
            if viewModel.codeSent {
                Text(viewModel.codeSentMessage)
                TextField("Code", text: self.$viewModel.code)
                   .padding()
                   .keyboardType(.alphabet)
                   .autocapitalization(.none)
                
                SecureField("New Password", text: self.$viewModel.password)
                    .padding()
                    .cornerRadius(20)
                
            } else {
                Text("Reset your password")
                               .font(.headline)
                TextField("Username", text: self.$viewModel.username)
                    .padding()
                    .keyboardType(.alphabet)
                    .autocapitalization(.none)
            }
            
            Button(action:{
                if self.viewModel.codeSent {
                    self.viewModel.confirmForgotPassword {
                        self.showSelf = false
                    }
                } else {
                    self.viewModel.sendCode()
                }
            }) {
                Text(self.viewModel.codeSent ? "Submit" : "Send Code")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
            
            Spacer()
            
            
        }.padding()
            .navigationBarItems(leading: Button(action: {self.showSelf=false}, label: { Text("Back")
            }))
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForgotPasswordView(showSelf: .constant(true))
        }
    }
}
