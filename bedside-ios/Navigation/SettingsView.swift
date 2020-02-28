//
//  SettingsView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import AWSMobileClient

struct SettingsView: View {
    
    @Binding var rootIsActive : Bool
    
    func signOut() {
        AWSMobileClient.default().signOut()
        rootIsActive = false
    }
    
    var body: some View {
        VStack {
            Button(action: {self.signOut()}) {
                Text("Sign Out")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(rootIsActive: .constant(true))
    }
}
