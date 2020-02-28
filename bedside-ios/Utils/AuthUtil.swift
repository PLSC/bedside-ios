//
//  Auth.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import AWSMobileClient

class AuthUtil: ObservableObject {
    
    @Published var isSignedIn : Bool = false
    
    
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
    
    func signIn(userName: String, password: String) {
        AWSMobileClient.default().signIn(username: userName, password: password) { (signInResult, error) in
            if let error = error  {
                print("\(error.localizedDescription)")
            } else if let signInResult = signInResult {
                switch (signInResult.signInState) {
                case .signedIn:
                    if let user = AWSMobileClient.default().username {
                        let loggedInMessage = "User is signed in: \(user)"
                        print(loggedInMessage)
                    }
                case .smsMFA:
                    print("SMS message sent to \(signInResult.codeDetails!.destination!)")
                default:
                    print("Sign In needs info which is not yet supported.")
                }
            }
        }
    }
    
    func signOut() {
        AWSMobileClient.default().signOut()
    }
}
