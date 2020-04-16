//
//  SettingsView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import AWSMobileClient

class UserSettingsFormViewModel : ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
}

struct SettingsView: View {
    
    @ObservedObject var viewModel = UserSettingsFormViewModel()
    
    let authUtil = AuthUtils()
        
    func signOut() {
        authUtil.signOut()
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
            
            
            
            Button(action: {self.signOut()}) {
                Text("Sign Out")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
