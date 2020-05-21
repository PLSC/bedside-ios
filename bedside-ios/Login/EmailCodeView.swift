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
    @State var showError: Bool = false
    @State var errorTitle: String = "Error"
    @State var errorMessage: String = ""
    
    let authUtils = AuthUtils()
    
    func submitCode() {
        authUtils.confirmSignUp(username: self.username, confirmationCode: self.confirmationCode) { (result) in
            switch result {
            case .success(_):
                self.showSelf = false
            case .failure(_):
                self.showError = true
                self.errorMessage = "Invalid verification code provided. Please try again."
            }
        }
    }
    
    func resendCode() {
        authUtils.resendConfirmationCode(username: self.username) { (result) in
            switch result {
            case .success(let signupResult):
                print("Confirmation code sent to \(signupResult.codeDeliveryDetails!.destination!)")
            case .failure(let error):
                self.showError = true
                self.errorMessage = "Failure to send confirmation code. \(error.localizedDescription)"
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
            .alert(isPresented: $showError) { () -> Alert in
                Alert(title: Text(self.errorTitle),
                      message: Text(self.errorMessage),
                      dismissButton: .default(Text("OK")))
        }
    }
}

struct EmailCodeView_Previews: PreviewProvider {
    static var previews: some View {
        EmailCodeView(showSelf: .constant(true), username: .constant("alenox"), confirmationCode: "")
    }
}
