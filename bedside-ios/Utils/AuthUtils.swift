//
//  AuthUtils.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/2/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import AWSMobileClient

class AuthUtils {
    func sendAuthCode(username: String,  callback: @escaping (Bool, String)->()) {
        AWSMobileClient.default().forgotPassword(username: username) { (result, error) in
            if let forgotPasswordResult = result {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .confirmationCodeSent:
                    let confirmationMessage = "Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)"
                    print(confirmationMessage)
                    callback(true, confirmationMessage)
                default:
                    callback(false, "Error: Unknown Error.")
                }
            } else if let error = error {
                callback(false, "Error occurred: \(error.localizedDescription)")
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
    
    func confirmForgotPassword(username: String,
                               newPassword:String,
                               code: String,
                               callback: @escaping (Bool, String)->())  {
        AWSMobileClient.default()
            .confirmForgotPassword(username: username,
                                newPassword: newPassword,
                                confirmationCode: code) { (result, error) in
            if let forgotPasswordResult = result {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .done:
                    callback(true, "Password changed successfully")
                default:
                    callback(false, "Error: Could not change password.")
                }
            } else if let error = error {
                callback(false, "Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    func signOut() {
        AWSMobileClient.default().signOut()
    }
}
