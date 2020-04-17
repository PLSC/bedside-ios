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
    
    let authUtil = AuthUtils()
    
    //TODO: Put this into the environment with a bindable object.
    func getUser() {
        authUtil.fetchUserInfo { (userItem) in
            self.viewModel.firstName = userItem.firstName ?? ""
            self.viewModel.lastName = userItem.lastName ?? ""
            self.viewModel.npi = ""
            self.viewModel.username = userItem.userName ?? ""
            self.viewModel.id = userItem.id
            self.viewModel.email = userItem.email
            if let npi = userItem.npi {
                self.viewModel.npi = String(describing: npi)
            }
        }
    }
        
    func signOut() {
        authUtil.signOut()
    }
    
    func submit() {
        UIApplication.shared.endEditing()
        let npi = Int(viewModel.npi)
        let updateUserInput = UpdateUserInput(id: viewModel.id, firstName: viewModel.firstName, lastName: viewModel.lastName, npi: npi)
        self.authUtil.updateUser(updateUserInput: updateUserInput)
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
