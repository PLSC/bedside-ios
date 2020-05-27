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
    
    func submitCode(username: String, completion: @escaping (Result<Bool, EmailCodeError>)->()) {
        authUtils.confirmSignUp(username: username, confirmationCode: self.confirmationCode) { (result) in
            
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(_):
                completion(.failure(.invalidCode("Invalid verification code provided. Please try again.")))
            }
        }
    }
    
    func resendCode(username: String, completion: @escaping (Result<String, EmailCodeError>)->()) {
        
        authUtils.resendConfirmationCode(username: username) { (result) in
            
            switch result {
            case .success(let signupResult):
                print("Confirmation code sent to \(signupResult.codeDeliveryDetails!.destination!)")
                guard let destination = signupResult.codeDeliveryDetails?.destination else {
                    print("no details in code delivery status")
                    return
                }
                
                let codeSentMessage = "Confirmation code sent to \(destination)"
                
                completion(.success(codeSentMessage))
            case .failure(_):
                completion(.failure(.codeNotSent("Confirmation failed to send.")))
            }
        }
    }
}

struct EmailCodeView: View {
    
    //TODO: sending/waiting state for spinner and disabling UI elements.
    @Binding var showSelf: Bool
    @Binding var username: String
    @State var keyboardHeight: CGFloat = 0
    @State var showAlert : Bool = false
    @State var showError : Bool = false
    @State var alertMessage: String = ""
    @State var alertTitle: String = ""
    @State var loading: Bool = false
    
    @ObservedObject var viewModel = EmailCodeViewModel()
    
    func submitCode()  {
        self.loading = true
        self.viewModel.submitCode(username: username) { (result) in
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
    }
    
    func resendCode() {
        self.viewModel.resendCode(username: username) {
            result in
        
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
