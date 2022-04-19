//
//  ForgotUsernameView.swift
//  bedside-ios
//
//  Created by Sean Loiselle on 4/8/22.
//  Copyright © 2022 Andrew Lenox. All rights reserved.
//

import SwiftUI
import Combine

class ForgotUsernameViewModel : ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var loading = false
    @Published var showError = false
    @Published var errorTitle = "Error"
    @Published var errorMessage = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    let userService : UserService

    init(userService: UserService = AppSyncUserService()) {
        self.userService = userService
    }
    
    func reset()  {
        username = ""
        email = ""
        loading = false
        showError = false
        errorTitle = "Error"
        errorMessage = ""
    }
    
    func recoverUsername(email: String, action: @escaping (Result<Bool, Error>)->()) {
        self.loading = true
        print("recover username with email: \(email)")
        self.email = email
        DispatchQueue.main.async {
            self.userService.fetchUser(email: email) { (result) in
                switch result {
                case .success(let users):
                    self.username = (users.compactMap({ $0 }).first)?.userName ?? ""
                    print("Username: \(self.username)")
                        
                        action(.success(true))
                    self.loading = false
                case .failure(let error):
                    self.username = ""
                    print("username recovery failure: \(error)")
                    switch error {
                    case .noResults:
                        self.errorTitle = "Username not found"
                        self.errorMessage = "Login Error. A user account with this email address does not exist. Please check your entry and try again."
                    case .noAccount:
                        self.errorTitle = "Username not found"
                        self.errorMessage = "Login Error. A username with this email address does not exist. Please contact help@simpl-bedside.org for additional support."
                    default:
                         self.errorMessage = "An error has occurred: \(error.localizedDescription)"
                    }
                    self.loading = false
                    self.showError = true
                    action(.failure(error))
                }
            }
        }

        
    }
}

struct ForgotUsernameView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var forgotUsernameViewModel : ForgotUsernameViewModel
    @Binding var username : String
    @State var email = ""
    @State var keyboardHeight : CGFloat = 0
    
    init(username: Binding<String>) {
        self._username = username
    }
    
    var recoverUsernameButton: some View {
        Button(action:{
            self.forgotUsernameViewModel.recoverUsername(email: self.email) {
                result in
                switch result {
                case .success(_):
                    username = self.forgotUsernameViewModel.username
                    self.presentationMode.wrappedValue.dismiss()
                case .failure(_):
                    print("error in recoverUsername")
                }
            }
        })
         {
            Text("Recover Your Username")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.lightTeal)
                .cornerRadius(15.0)
        }
    }
    
    var body: some View {
        LoadingView(isShowing: self.$forgotUsernameViewModel.loading) {
            VStack(alignment: .center) {
                SIMPLBedsideLogoView()
                Text("Recover your username")
                               .font(.headline)
                TextField("email", text: self.$email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                self.recoverUsernameButton
                
                Spacer()
                
                Link("Help & Support", destination: URL(string: "https://simpl-support.freshdesk.com/support/solutions/70000215976")!)
            }
            .padding()
            .padding(.bottom, self.keyboardHeight)
            .onReceive(Publishers.keyboardHeight) {
                self.keyboardHeight = $0
            }
        }.alert(isPresented: self.$forgotUsernameViewModel.showError) {
            Alert(title: Text(self.forgotUsernameViewModel.errorTitle),
              message: Text(self.forgotUsernameViewModel.errorMessage),
              dismissButton: .default(Text("OK")))
        }
    }
    
}

