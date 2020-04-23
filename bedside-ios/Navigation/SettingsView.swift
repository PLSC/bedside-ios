//
//  SettingsView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import AWSMobileClient
import Amplify
import AWSS3

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

class UserSettingsFormViewModel : ObservableObject {
    @Published var username = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var npi = ""
    @Published var email = ""
    var id = ""
}

struct SettingsView: View {
    
    @ObservedObject var viewModel = UserSettingsFormViewModel()
    @EnvironmentObject var userLoginState : UserLoginState
    
    let authUtil = AuthUtils()
    
    //TODO: Put this into the environment with a bindable object.
    func getUser() {
        self.viewModel.firstName = self.userLoginState.currentUser?.firstName ?? ""
        self.viewModel.lastName = self.userLoginState.currentUser?.lastName ?? ""
        self.viewModel.npi = ""
        self.viewModel.username = self.userLoginState.currentUser?.userName ?? ""
        self.viewModel.id = self.userLoginState.currentUser?.id ?? ""
        self.viewModel.email = self.userLoginState.currentUser?.email ?? ""
        if let npi = self.userLoginState.currentUser?.npi {
            self.viewModel.npi = String(describing: npi)
        }
        
    }
        
    func signOut() {
        authUtil.signOut()
    }
    
    func submit() {
        UIApplication.shared.endEditing()
        let npi = Int(viewModel.npi)
        let user = User(id: viewModel.id, email: viewModel.email, firstName: viewModel.firstName, lastName: viewModel.lastName, npi: npi)
        self.userLoginState.updateUser(user: user)
    }
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Image("andy")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(maxHeight:75)
                       .clipShape(Circle())
                       .shadow(radius: 10)
                    VStack(alignment: .leading) {
                        (Text("Username: ").bold() + Text(viewModel.username)).padding()
                        (Text("Email: ").bold() + Text(viewModel.email)).padding()
                    }
                }
                
                HStack {
                    Text("First Name:").font(.callout).bold()
                    TextField("First Name", text: $viewModel.firstName, onEditingChanged: { didChange in
                        print("editingChanged: \(didChange)")
                    }, onCommit: {
                        print("committed")
                    }).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Last Name:").font(.callout).bold()
                    TextField("Last Name", text: $viewModel.lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("NPI: ").font(.callout).bold()
                    TextField("NPI", text:$viewModel.npi)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section {
                    Button(action: {self.submit()}) {
                        Text("Submit Changes")
                    }
                }
                
                Section {
                    Button(action: {self.signOut()}) {
                        Text("Sign Out").foregroundColor(Color.red)
                    }
                }
            }
            .onAppear { self.getUser() }
            //.modifier(DismissingKeyboard())
            .navigationBarTitle("Settings")
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
