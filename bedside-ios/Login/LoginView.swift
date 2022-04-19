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
    @Published var showForgotPassword: Bool = false
    @Published var showForgotUsername: Bool = false
    @Published var loading: Bool = false
    @Published var codeSent: Bool = false
    
    var authUtils : AuthUtils
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(authUtils: AuthUtils = AuthUtils()) {
        self.authUtils = authUtils
        
        Publishers.CombineLatest($username, $password)
            .receive(on: RunLoop.main)
            .map { username, password in
                return username.count > 2 && password.count > 7
            }
            .assign(to: \.formIsValid, on: self)
            .store(in: &cancellableSet)
    }
    
    func signIn() {
        self.loading = true
        authUtils.signIn(userName: username, password: password) {
            result in
            self.loading = false
            switch result {
            case .signedIn:
                self.username = ""
                self.password = ""
            case .needsConfirmation:
                self.showEmailCodeEnter = true
            case .signInError(let message):
                switch message {
                case "User not found":
                    self.loginErrorMessage = "A user account with this email address does not exist.  Please check your entry and try again."
                case "Incorrect username or password":
                    self.loginErrorMessage = "Sorry, that password isn’t right. Do you need to reset your password?"
                default:
                    self.loginErrorMessage = message
                }
                self.isLoginError = true
            case .resetPassword:
                self.password = ""
                self.showForgotPassword = true
                self.codeSent = true
            }
        }
    }
}

struct LoginView: View {
        
    @ObservedObject var viewModel = LoginViewModel()
    @State private var keyboardHeight : CGFloat = 0

    
    var body: some View {
        LoadingView(isShowing: $viewModel.loading) {
            NavigationView {
                VStack(alignment: HorizontalAlignment.center, spacing: 15) {
                    
                    SIMPLBedsideLogoView()
                    
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
                            .background(self.viewModel.formIsValid ? Color.lightTeal : Color.gray)
                            .cornerRadius(15.0)
                    }.disabled(!self.viewModel.formIsValid)
                    Group {
                        NavigationLink(destination: ForgotUsernameView( username: self.$viewModel.username), isActive:self.$viewModel.showForgotUsername) {
                            Text("")
                        }
                        
                        Button(action:{
                            self.viewModel.showForgotUsername = true
                            self.viewModel.username = ""
                        }) {
                            Text("Forgot Username")
                        }
                        
                        NavigationLink(destination: ForgotPasswordView(codeSent: self.$viewModel.codeSent, username: self.$viewModel.username), isActive:self.$viewModel.showForgotPassword) {
                            Text("")
                        }
                        
                        Button(action:{
                            self.viewModel.showForgotPassword = true
                            self.viewModel.password = ""
                        }) {
                            Text("Forgot Password")
                        }

                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }
                        NavigationLink(destination: EmailCodeView(showSelf: self.$viewModel.showEmailCodeEnter, username: self.$viewModel.username), isActive: self.$viewModel.showEmailCodeEnter) {
                            Text("")
                        }
                        
                        Spacer()
                        
                        Link("Help & Support", destination: URL(string: "https://simpl-support.freshdesk.com/support/solutions/70000215976")!)
                    }
                    
                }.ignoresSafeArea(.keyboard, edges: .bottom)
            }.alert(isPresented: self.$viewModel.isLoginError) {
                Alert(title: Text("Login Error"), message: Text(self.viewModel.loginErrorMessage), dismissButton: .default(Text("OK")))
            }
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

struct SIMPLBedsideLogoView: View {
    var body: some View {
        HStack(spacing:30) {
            Image("bedicon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight:100)
            VStack(alignment:.leading) {
                Text("SIMPL")
                    .font(.system(.largeTitle, design: .rounded))
                Text("Bedside")
                    .font(.system(.largeTitle, design: .rounded))
                    .foregroundColor(.gray)
            }
        }
    }
}
