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
    @Published var showError: Bool = false
    @Published var errorTitle: String = "Error"
    @Published var errorMessage: String = ""
    
    @Published var codeSentMessage: String = ""
    @Published var showCodeSentMessage : Bool = false
    @Published var sendCodeButtonEnabled : Bool = true
    @Published var showAlert : Bool = false
    
    @Published var submittingCode : Bool = false
    
    var cancellableSet : Set<AnyCancellable> = []
    let authUtils : AuthUtils
    
    enum EmailCodeError : Error {
        case invalidCode(String)
    }
    
    init(authUtils : AuthUtils = AuthUtils()) {
        self.authUtils = authUtils
        
        Publishers.CombineLatest($showError, $showCodeSentMessage)
            .receive(on: RunLoop.main)
            .map { (showError, showCodeSent) in
                return showError || showCodeSent
            }.assign(to: \.showAlert, on: self)
            .store(in: &cancellableSet)
    }
    
    func submitCode(username: String, completion: @escaping (Result<Bool, EmailCodeError>)->()) {
        self.submittingCode = true
        authUtils.confirmSignUp(username: username, confirmationCode: self.confirmationCode) { (result) in
            self.submittingCode = false
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(_):
                self.showError = true
                self.errorMessage = "Invalid verification code provided. Please try again."
                completion(.failure(.invalidCode("Invalid verification code provided. Please try again.")))
            }
        }
    }
    
    func resendCode(username: String) {
        sendCodeButtonEnabled = false
        authUtils.resendConfirmationCode(username: username) { (result) in
            self.sendCodeButtonEnabled = true
            switch result {
            case .success(let signupResult):
                print("Confirmation code sent to \(signupResult.codeDeliveryDetails!.destination!)")
                guard let destination = signupResult.codeDeliveryDetails?.destination else {
                    print("no details in code delivery status")
                    return
                }
                self.showCodeSentMessage = true
                self.codeSentMessage = "Confirmation code sent to \(destination)"
            case .failure(let error):
                self.showError = true
                self.errorMessage = "Failure to send confirmation code. \(error.localizedDescription)"
            }
        }
    }
}

struct EmailCodeView: View {
    
    //TODO: sending/waiting state for spinner and disabling UI elements.
    @Binding var showSelf: Bool
    @Binding var username: String
    @State var keyboardHeight: CGFloat = 0
    
    
    @ObservedObject var viewModel = EmailCodeViewModel()
    
    func submitCode()  {

        self.viewModel.submitCode(username: username) { (result) in
            switch result {
            case .success(_):
                self.showSelf = false
            case .failure(_):
                print("submit code error")
            }
        }
    }
    
    func resendCode() {
        self.viewModel.resendCode(username: username)
    }
    
    var body: some View {
        LoadingView(isShowing: self.$viewModel.submittingCode, progress: nil) {
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
                }.disabled(!self.viewModel.sendCodeButtonEnabled)
                
                Spacer()
                
            }.padding()
                .padding(.bottom, self.keyboardHeight)
                .onReceive(Publishers.keyboardHeight) {
                        self.keyboardHeight = $0
                }
            .alert(isPresented: self.$viewModel.showAlert) {
                    if self.viewModel.showError {
                        return self.errorAlert
                    } else {
                        return self.codeSentAlert
                    }
                }
        }
        
    }
    
    var codeSentAlert : Alert {
        Alert(title: Text("Code Sent"),
              message: Text(self.viewModel.codeSentMessage),
              dismissButton: .default(Text("OK")))
    }
    
    var errorAlert : Alert {
        Alert(title: Text(self.viewModel.errorTitle),
              message: Text(self.viewModel.errorMessage),
              dismissButton: .default(Text("OK")))
    }
}

struct EmailCodeView_Previews: PreviewProvider {
    static var previews: some View {
        EmailCodeView(showSelf: .constant(true), username: .constant("alenox"))
    }
}
