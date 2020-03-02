//
//  StartupContainerView.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/2/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI

struct StartupContainerView: View {
    
    @EnvironmentObject var authUtil : LoggedInState
    
    @ViewBuilder
    var body: some View {
        if authUtil.isSignedIn {
            BaseView()
        } else {
            LoginView()
        }
    }
}

struct StartupContainerView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let loggedIn = LoggedInState()
        loggedIn.isSignedIn = true
        let loggedOut = LoggedInState()
        loggedOut.isSignedIn = false
        
        return Group {
            
            StartupContainerView().environmentObject(loggedIn)
            StartupContainerView().environmentObject(loggedOut)
        }
        
    }
}
