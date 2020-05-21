//
//  ForgotPasswordView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/2/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import Combine


class ForgotPasswordViewModel : ObservableObject {
    @Published var username = ""
    @Published var password : String = ""
    @Published var codeSent = false
    @Published var code = ""
    @Published var codeSentMessage = ""
    @Published var success = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var formDataIsValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    let authUtil : AuthUtils
    
    var passwordIsValid : AnyPublisher<Bool, Never> {
        $password.map {
            $0.count > 5
        }.eraseToAnyPublisher()
    }
    
    var codeIsValid : AnyPublisher<Bool, Never> {
        $code.map { $0.count > 5 }.eraseToAnyPublisher()
    }
    
    init(authUtil: AuthUtils = AuthUtils()) {
        self.authUtil = authUtil
        
        Publishers.CombineLatest(codeIsValid, passwordIsValid)
            .receive(on: RunLoop.main)
            .map { (codeIsValid, passwordIsValid)  in
                return codeIsValid && passwordIsValid
        }.assign(to: \.formDataIsValid, on: self)
        .store(in: &cancellableSet)
    }
    
    func sendCode() {
        authUtil.sendAuthCode(username: username) {
            result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self.codeSentMessage = message
                    self.codeSent = true
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = "An error has occurred: \(error.localizedDescription)"
                }
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
    
    @EnvironmentObject var authUtil : UserLoginState
    @ObservedObject var viewModel = ForgotPasswordViewModel()
    @Binding var showSelf : Bool
    @State var keyboardHeight : CGFloat = 0
    
    var sendCodeButton: some View {
        Button(action:{
            self.viewModel.sendCode()
        }) {
            Text("Send Code")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.blue)
                .cornerRadius(15.0)
        }
    }
    
    var submitNewPasswordButton: some View {
        Button(action:{
            self.viewModel.confirmForgotPassword {
                self.showSelf = false
            }
        }) {
            Text("Submit")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
                .background(self.viewModel.formDataIsValid ? Color.blue : Color.gray)
                .cornerRadius(15.0)
                .disabled(!self.viewModel.formDataIsValid)
        }
    }
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
            
            if self.viewModel.codeSent {
                self.submitNewPasswordButton
            } else {
                self.sendCodeButton
            }
            
            
            
            Spacer()
            
            
        }.padding()
            .padding(.bottom, self.keyboardHeight)
                .onReceive(Publishers.keyboardHeight) {
                    self.keyboardHeight = $0
            }
            .alert(isPresented: self.$viewModel.showError) {
            Alert(title: Text("Error"), message: Text(self.viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForgotPasswordView(showSelf: .constant(true))
        }
    }
}
