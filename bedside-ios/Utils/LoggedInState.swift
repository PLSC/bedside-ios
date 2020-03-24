//
//  LoggedInState.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import AWSMobileClient

class LoggedInState: ObservableObject {
    
    @Published var isSignedIn : Bool = false
    @Published var userState : UserState = .unknown
    
    
    func setIsSignedIn(userState: UserState) {
        switch (userState) {
        case .guest: fallthrough
        case .signedIn:
            self.isSignedIn = true
        case .signedOut: fallthrough
        case .signedOutFederatedTokensInvalid: fallthrough
        case .signedOutUserPoolsTokenInvalid: fallthrough
        case .unknown:
            self.isSignedIn = false
        }
    }
    
    init() {
        AWSMobileClient.default().initialize { (userState, error) in
            if let userState = userState {
                self.setIsSignedIn(userState: userState)
                self.userState = userState
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        
        AWSMobileClient.default()
            .addUserStateListener(self) { (userState, info) in
                print("userState change \(userState)")
                DispatchQueue.main.async {
                    self.setIsSignedIn(userState: userState)
                }
        }
    }
}
