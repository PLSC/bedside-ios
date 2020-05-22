//
//  ContentView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/12/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import Combine
import AWSMobileClient

class LoginViewModel : ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var formIsValid = false
    @Published var showEmailCodeEnter = false
    @Published var loginErrorMessage : String = ""
    @Published var isLoginError : Bool = false
    
    var authUtils : AuthUtils
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(authUtils: AuthUtils = AuthUtils()) {
        self.authUtils = authUtils
        
        Publishers.CombineLatest($username, $password)
            .receive(on: RunLoop.main)
            .map { username, password in
                return username.count > 2 && password.count > 5
            }
            .assign(to: \.formIsValid, on: self)
            .store(in: &cancellableSet)
    }
    
    func signIn() {
        authUtils.signIn(userName: username, password: password) {
            result in
            switch result {
            case .signedIn:
                self.username = ""
                self.password = ""
            case .needsConfirmation:
                self.showEmailCodeEnter = true
            case .signInError(let message):
                self.loginErrorMessage = message
                self.isLoginError = true
            }
        }
    }
}

struct LoginView: View {
        
    @ObservedObject var viewModel = LoginViewModel()
    @State private var showForgotPassword = false
    @State private var keyboardHeight : CGFloat = 0

    
    var body: some View {
        NavigationView {
            VStack(alignment: HorizontalAlignment.center, spacing: 15) {
                Text("Bedside Procedures")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .padding([.top, .bottom], 20)
                    
                TextField("Username", text: self.$viewModel.username)
                    .padding()
                    .keyboardType(.alphabet)
                    .autocapitalization(.none)

                SecureField("Password", text: self.$viewModel.password)
                    .padding()
                    .cornerRadius(20)

                Button(action:{ self.viewModel.signIn()}) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(self.viewModel.formIsValid ? Color.blue : Color.gray)
                        .cornerRadius(15.0)
                }.disabled(!self.viewModel.formIsValid)
                
                NavigationLink(destination: ForgotPasswordView(showSelf:$showForgotPassword), isActive:$showForgotPassword) {
                    Text("")
                }
                
                Button(action:{
                    self.showForgotPassword = true
                }) {
                    Text("Forgot Password")
                }
                
                NavigationLink(destination: EmailCodeView(showSelf: $viewModel.showEmailCodeEnter, username: self.$viewModel.username), isActive: $viewModel.showEmailCodeEnter) {
                    Text("")
                }
                
                Spacer()
                
            }.padding()
                .padding(.bottom, self.keyboardHeight)
                .onReceive(Publishers.keyboardHeight) {
                    self.keyboardHeight = $0
            }
        }.alert(isPresented: $viewModel.isLoginError) {
            Alert(title: Text("Login Error"), message: Text(self.viewModel.loginErrorMessage), dismissButton: .default(Text("OK")))
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
