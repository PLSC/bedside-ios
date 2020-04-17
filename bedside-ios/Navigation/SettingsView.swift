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

class UserSettingsFormViewModel : ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var npi = ""
    var id = ""
}

struct SettingsView: View {
    
    @ObservedObject var viewModel = UserSettingsFormViewModel()
    
    let authUtil = AuthUtils()
    
    func getUser() {
        authUtil.fetchUserInfo { (userItem) in
            self.viewModel.firstName = userItem.firstName ?? ""
            self.viewModel.lastName = userItem.lastName ?? ""
            self.viewModel.npi = ""
            self.viewModel.id = userItem.id
            if let npi = userItem.npi {
                self.viewModel.npi = String(describing: npi)
            }
        }
    }
        
    func signOut() {
        authUtil.signOut()
    }
    
    func submit() {
        let npi = Int(viewModel.npi)
        let updateUserInput = UpdateUserInput(id: viewModel.id, firstName: viewModel.firstName, lastName: viewModel.lastName, npi: npi)
        self.authUtil.updateUser(updateUserInput: updateUserInput)
    }
    
    var body: some View {
        Form {
            
            Image("andy")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight:150)
                .clipShape(Circle())
                .shadow(radius: 10)
        
            TextField("First Name", text: $viewModel.firstName)
            TextField("Last Name", text: $viewModel.lastName)
            TextField("NPI", text: $viewModel.npi).keyboardType(.numberPad)
            
            Section {
                Button(action: {self.submit()}) {
                    Text("Submit Changes")
                }
            }
            
            Section {
                Button(action: {self.signOut()}) {
                               Text("Sign Out")
                           }
            }
           
        }.onAppear { self.getUser() }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
