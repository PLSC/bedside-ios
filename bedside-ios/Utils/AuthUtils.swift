//
//  AuthUtils.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/2/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import AWSMobileClient
import Amplify

enum SignInResult {
    case signedIn
    case needsConfirmation
    case signInError(String)
    case resetPassword
}

enum AuthUtilsError : Error {
    case unknownError
}

class AuthUtils {
    func sendAuthCode(username: String,  callback: @escaping (Result<String, Error>)->()) {
        AWSMobileClient.default().forgotPassword(username: username) { (result, error) in
            DispatchQueue.main.async {
                if let forgotPasswordResult = result {
                    switch(forgotPasswordResult.forgotPasswordState) {
                    case .confirmationCodeSent:
                        let confirmationMessage = "Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)"
                        print(confirmationMessage)
                        callback(.success(confirmationMessage))
                    default:
                        callback(.failure(AuthUtilsError.unknownError))
                    }
                } else if let error = error {
                    callback(.failure(error))
                }
            }
        }
    }
    
    func signIn(userName: String, password: String,  completion: @escaping (SignInResult) -> Void) {
        AWSMobileClient.default().signIn(username: userName, password: password) { (signInResult, error) in
            DispatchQueue.main.async {
                if let error = error as? AWSMobileClientError  {
                    switch error {
                    case .userNotConfirmed(let message):
                        print(message)
                        completion(.needsConfirmation)
                    case .notAuthorized(let message):
                        completion(.signInError(message))
                    case .userNotFound(_):
                        completion(.signInError("User not found"))
                    case .passwordResetRequired(_):
                        completion(.resetPassword)
                    default:
                        completion(.signInError("Unknown Error: \(error.localizedDescription)"))
                    }
                } else if let signInResult = signInResult {
                    switch (signInResult.signInState) {
                    case .signedIn:
                        completion(.signedIn)
                    case .smsMFA:
                        print("SMS message sent to \(signInResult.codeDetails!.destination!)")
                    case .newPasswordRequired:
                        print("TODO: go to new password screen")
                    default:
                        print("Sign In needs info which is not yet supported.")
                    }
                }
            }
        }
    }
    
    func fetchUserInfo(callback: @escaping (UsersByEmailQuery.Data.UsersByEmail.Item)->()) {
        //get logged in user email
        AWSMobileClient.default().getUserAttributes { (attributes, error) in
            if let e = error {
                print("Error getting user attributes: \(e.localizedDescription)")
            }
            if let email = attributes?["email"] {
                self.fetchUserInfo(email: email, callback: callback)
            }
        }
    }
    
    func fetchUserInfo(email: String, callback: @escaping (UsersByEmailQuery.Data.UsersByEmail.Item)->()) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let appSyncClient = appDelegate.appSyncClient
            appSyncClient?.fetch(query:  UsersByEmailQuery(email: email, limit: 1), cachePolicy: .returnCacheDataAndFetch) {
                (result, error ) in
                if let e = error {
                    print("error with UsersByEmailQuery: \(e.localizedDescription)")
                }
                if let userItem = result?.data?.usersByEmail?.items?.compactMap({ $0 }).first {
                    callback(userItem)
                    if let orgId = userItem.memberships?.items?[0]?.program.orgId {
                        appSyncClient?.fetch(query: GetOrganizationQuery(id: orgId), cachePolicy: .returnCacheDataAndFetch) {
                            (result, error) in
                            print(result ?? "")
                        }
                    }
                }
            }
        }
    }
    
    func updateUser(updateUserInput: UpdateUserInput) {
        let mutation = UpdateUserMutation(input: updateUserInput)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        appSyncClient?.perform(mutation: mutation, resultHandler: { (data, error) in
            print("appsync update complete")
        })
    }
    
    func confirmForgotPassword(username: String,
                               newPassword:String,
                               code: String,
                               callback: @escaping (Bool, String)->())  {
        AWSMobileClient.default()
            .confirmForgotPassword(username: username,
                                newPassword: newPassword,
                                confirmationCode: code) { (result, error) in
                                    DispatchQueue.main.async {
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
    }
    //TODO: Make internal type for SignInResult.
    func confirmSignUp(username: String, confirmationCode: String, completion: @escaping (Result<SignUpResult, Error>)->()) {
        AWSMobileClient.default().confirmSignUp(username: username, confirmationCode: confirmationCode) { (signUpResult, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let signUpResult = signUpResult {
                    completion(.success(signUpResult))
                }
            }
        }
    }
    
    func resendConfirmationCode(username: String, completion: @escaping (Result<SignUpResult, Error>)->()) {
        AWSMobileClient.default().resendSignUpCode(username: username, completionHandler: { (result, error) in
//            if let signUpResult = result {
//                let message = "A verification code has been sent via \(signUpResult.codeDeliveryDetails!.deliveryMedium) at \(signUpResult.codeDeliveryDetails!.destination!)"
//                print(message)
//                completion(message, nil)
//            } else if let error = error {
//                completion("A problem has occurred", error)
//            }
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let result = result {
                    completion(.success(result))
                }
            }
        })
    }
    
    func signOut() {
        AWSMobileClient.default().signOut()
    }
}
