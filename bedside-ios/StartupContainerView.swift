//
//  StartupContainerView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/2/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct StartupContainerView: View {

    @EnvironmentObject var authUtil : UserLoginState
    
    @ViewBuilder
    var body: some View {
        if authUtil.isSignedIn {
            BaseView().accentColor(Color.simplTeal)
        } else {
            LoginView().accentColor(Color.simplTeal)
        }
    }
}

struct StartupContainerView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let loggedIn = UserLoginState()
        loggedIn.isSignedIn = true
        let loggedOut = UserLoginState()
        loggedOut.isSignedIn = false
        
        return Group {
            
            StartupContainerView().environmentObject(loggedIn)
            StartupContainerView().environmentObject(loggedOut)
        }
        
    }
}
