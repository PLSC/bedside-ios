//
//  EmailCodeView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/24/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import Combine



class EmailCodeViewModel : ObservableObject {
    @Published var confirmationCode: String = ""

    
    var cancellableSet : Set<AnyCancellable> = []
    let authUtils : AuthUtils
    
    enum EmailCodeError : Error {
        case invalidCode(String)
        case codeNotSent(String)
    }
    
    init(authUtils : AuthUtils = AuthUtils()) {
        self.authUtils = authUtils
    }
    
    func submitCode(username: String) async -> Result<Bool, EmailCodeError> {
        let result = await authUtils.confirmSignUp(username: username, confirmationCode: self.confirmationCode)

        switch result {
        case .success(_):
            return .success(true)
        case .failure(_):
            return .failure(.invalidCode("Invalid verification code provided. Please try again."))
        }
    }
    
    func resendCode(username: String) async -> Result<String, EmailCodeError> {

        let result = await authUtils.resendConfirmationCode(username: username)

        switch result {
        case .success(_):
            let codeSentMessage = "Confirmation code sent to email"

            return .success(codeSentMessage)
        case .failure(_):
            return .failure(.codeNotSent("Confirmation failed to send."))
        }
    }
}

struct EmailCodeView: View {
    @Binding var showSelf: Bool
    @Binding var username: String
    @State var keyboardHeight: CGFloat = 0
    @State var showAlert : Bool = false
    @State var showError : Bool = false
    @State var alertMessage: String = ""
    @State var alertTitle: String = ""
    @State var loading: Bool = false
    
    @ObservedObject var viewModel = EmailCodeViewModel()
    
    func submitCode() async {
        self.loading = true
        let result = await self.viewModel.submitCode(username: username)

        self.loading = false
        switch result {
        case .success(_):
            self.showSelf = false
        case .failure(_):
            self.showAlert = true
            self.showError = true
            self.alertMessage = "Invalid verification code provided. Please try again."
            print("submit code error")
        }
    }
    
    func resendCode() async {
        let result = await self.viewModel.resendCode(username: username)

        switch result {
        case .success(let successMessage):
            self.showAlert = true
            self.showError = false
            self.alertMessage = successMessage
            self.alertTitle = "Code Sent"
        case .failure(_):
            self.showAlert = true
            self.showError = true
            self.alertTitle = "Error"
            self.alertMessage = "Failed to send code."
        }
    }
    
    var body: some View {
        LoadingView(isShowing: self.$loading) {
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
                
                TextField("Confirmation Code", text: self.$viewModel.confirmationCode)
                    .padding()
                    .keyboardType(.numberPad)
                
                Button(action:{
                    Task {
                        await self.submitCode()
                    }
                }) {
                  Text("Confirm")
                      .font(.headline)
                      .foregroundColor(.white)
                      .padding()
                      .frame(width: 300, height: 50)
                      .background(Color.lightTeal)
                      .cornerRadius(15.0)
                }
                
                Button(action:{
                    Task {
                        await self.resendCode()
                    }
                }) {
                    Text("Resend Code")
                        .padding()
                }.disabled(self.loading)
                
                Spacer()
                
            }
            .padding()
            .padding(.bottom, self.keyboardHeight)
            .onReceive(Publishers.keyboardHeight) {
                    self.keyboardHeight = $0
            }
            .alert(isPresented: self.$showAlert) {
                self.codeSendAlert
            }
        }
        
    }
    
    var codeSendAlert : Alert {
        Alert(title: Text(self.alertTitle),
              message: Text(self.alertMessage),
              dismissButton: .default(Text("OK")))
    }
}

struct EmailCodeView_Previews: PreviewProvider {
    static var previews: some View {
        EmailCodeView(showSelf: .constant(true), username: .constant("alenox"))
    }
}
