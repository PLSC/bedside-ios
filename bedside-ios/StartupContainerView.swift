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

    @State private var loading = true
    @State private var bodyView = AnyView(EmptyContentView())

    @ViewBuilder
    var body: some View {
        LoadingView(isShowing: $loading) {
            bodyView
        }
        .onAppear {
            Task {
                await authUtil.validateCurrentAuthSession()

            }
        }
        .onChange(of: authUtil.isSignedIn) { status in
            self.loading = false

            if status ?? false {
                bodyView = AnyView(BaseView().accentColor(Color.simplTeal))
            } else {
                bodyView = AnyView(LoginView().accentColor(Color.simplTeal))
            }
        }
    }

}

struct EmptyContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Color.clear
            Spacer()
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
