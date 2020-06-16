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
    @Published var repeatPassword : String = ""
    @Published var codeSent = false
    @Published var code = ""
    @Published var success = false
    @Published var showError = false
    @Published var errorTitle = "Error"
    @Published var errorMessage = ""
    @Published var formDataIsValid = false
    @Published var loading = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    let authUtil : AuthUtils
    
    var passwordIsValid : AnyPublisher<Bool, Never> {
        $password.map {
            $0.count > 7
        }.eraseToAnyPublisher()
    }
    
    var repeatPasswordIsValid : AnyPublisher<Bool, Never> {
        $repeatPassword.map {
            $0.count > 7
        }.eraseToAnyPublisher()
    }
    
    var passwordsMatch : AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $repeatPassword)
            .map { password, repeatPassword in
                password == repeatPassword
        }.eraseToAnyPublisher()
    }
    
    var codeIsValid : AnyPublisher<Bool, Never> {
        $code.map { $0.count > 5 }.eraseToAnyPublisher()
    }
    
    init(authUtil: AuthUtils = AuthUtils()) {
        self.authUtil = authUtil
        
        Publishers.CombineLatest4(codeIsValid, passwordIsValid, repeatPasswordIsValid, passwordsMatch)
            .receive(on: RunLoop.main)
            .map {
                return $0 && $1 && $2 && $3
            }
            .assign(to: \.formDataIsValid, on: self)
            .store(in: &cancellableSet)
    }
    
    func sendCode(username: String, callback: @escaping (Bool, String) -> ()) {
        self.loading = true
        authUtil.sendAuthCode(username: username) {
            result in
            self.loading = false
            switch result {
            case .success(let message):
                callback(true, message)
            case .failure(let error as AuthUtilsError):
                self.showError = true
                self.errorTitle = "Error"
                switch error {
                case .userNotFound(let message):
                    self.errorTitle = "User not found"
                    self.errorMessage = message
                case .limitExceeded:
                    self.errorTitle = "Limit Exceeded"
                    self.errorMessage = "Request limit exceeded. Please try again later."
                default:
                     self.errorMessage = "An error has occurred: \(error.localizedDescription)"
                }
            case .failure(let error):
                self.showError = true
                self.errorMessage = "An unknown error has occurred: \(error.localizedDescription)"
            }
       }
    }
       
    func confirmForgotPassword(username: String, action: @escaping ()->()) {
        self.loading = true
        authUtil.confirmForgotPassword(username: username, newPassword: password, code: code) {
            success, message in
            DispatchQueue.main.async {
                self.loading = false
                self.success = true
                action()
            }
        }
   }
}

struct ForgotPasswordView: View {
    
    
    @EnvironmentObject var forgotPasswordViewModel : ForgotPasswordViewModel
    @Binding var showSelf : Bool
    @Binding var codeSent : Bool
    @Binding var username : String
    @State var keyboardHeight : CGFloat = 0
    @State var codeSentMessage = ""
    @State var showAlert = false
    
    init(showSelf: Binding<Bool>, codeSent: Binding<Bool>, username: Binding<String>) {
        self._showSelf = showSelf
        self._codeSent = codeSent
        self._username = username
    }
    
    var sendCodeButton: some View {
        Button(action:{
            self.forgotPasswordViewModel.sendCode(username: self.username) { sent, message in
                self.codeSent = sent
                self.codeSentMessage = message
            }
        }) {
            Text("Send Code")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.lightTeal)
                .cornerRadius(15.0)
        }
    }
    
    var submitNewPasswordButton: some View {
        Button(action:{
            self.forgotPasswordViewModel.confirmForgotPassword(username: self.username) {
                self.showSelf = false
            }
        }) {
            Text("Submit")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
                .background(self.forgotPasswordViewModel.formDataIsValid ? Color.lightTeal : Color.gray)
                .cornerRadius(15.0)
                .disabled(!self.forgotPasswordViewModel.formDataIsValid)
        }
    }
    var body: some View {
        LoadingView(isShowing: self.$forgotPasswordViewModel.loading) {
            VStack {
                if self.codeSent {
                    Text(self.codeSentMessage)
                        .lineLimit(3)
                    
                    TextField("Code", text: self.$forgotPasswordViewModel.code)
                       .padding()
                       .keyboardType(.numberPad)
                       .autocapitalization(.none)
                    
                    SecureField("New Password", text: self.$forgotPasswordViewModel.password)
                        .padding()
                        .cornerRadius(20)
                        .autocapitalization(.none)
                    
                    SecureField("Repeat Password", text: self.$forgotPasswordViewModel.repeatPassword)
                        .padding()
                        .cornerRadius(20)
                        .autocapitalization(.none)
                    
                    self.submitNewPasswordButton
                } else {
                    Text("Reset your password")
                                   .font(.headline)
                    TextField("Username", text: self.$username)
                        .padding()
                        .keyboardType(.alphabet)
                        .autocapitalization(.none)
                    self.sendCodeButton
                }
                
                Spacer()
                
            }
            .padding()
            .padding(.bottom, self.keyboardHeight)
            .onReceive(Publishers.keyboardHeight) {
                self.keyboardHeight = $0
            }
            .alert(isPresented: self.$forgotPasswordViewModel.showError) {
                Alert(title: Text(self.forgotPasswordViewModel.errorTitle),
                  message: Text(self.forgotPasswordViewModel.errorMessage),
                  dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForgotPasswordView(showSelf: .constant(true), codeSent: .constant(false), username: .constant(""))
        }
    }
}
