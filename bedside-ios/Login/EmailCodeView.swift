//
//  EmailCodeView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/24/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct EmailCodeView: View {
    
    //TODO: sending/waiting state for spinner and disabling UI elements.
    @Binding var showSelf: Bool
    @Binding var username: String
    @State var confirmationCode: String
    
    let authUtils = AuthUtils()
    
    //TODO: error handling, popup messages, etc.
    func submitCode() {
        print("submit code")
        authUtils.confirmSignUp(username: self.username, confirmationCode: self.confirmationCode) {
            self.showSelf = false
        }
    }
    
    //TODO: error handling, sent messages, etc.
    func resendCode() {
        authUtils.resendConfirmationCode(username: self.username) { (message, error) in
            if let err = error {
                print(err.localizedDescription)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Enter Confirmation Code")
                .font(.title)
                .foregroundColor(.gray)
                .padding([.top, .bottom], 20)
            
            TextField("Username", text: self.$username)
               .padding()
               .keyboardType(.alphabet)
               .autocapitalization(.none)
               .disabled(true)
            
            TextField("Confirmation Code", text: self.$confirmationCode)
                .padding()
                .keyboardType(.numberPad)
            
            Button(action:{self.submitCode()}) {
              Text("Confirm")
                  .font(.headline)
                  .foregroundColor(.white)
                  .padding()
                  .frame(width: 300, height: 50)
                  .background(Color.blue)
                  .cornerRadius(15.0)
            }
            
            Button(action:{
                self.resendCode()
            }) {
                Text("Resend Code")
                    .padding()
            }
            
            Spacer()
            
        }.padding()
    }
}

struct EmailCodeView_Previews: PreviewProvider {
    static var previews: some View {
        EmailCodeView(showSelf: .constant(true), username: .constant("alenox"), confirmationCode: "")
    }
}
