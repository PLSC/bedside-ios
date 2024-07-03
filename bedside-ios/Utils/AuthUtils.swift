//
//  AuthUtils.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/2/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import Amplify
import AWSCognitoAuthPlugin
import UIKit

enum SignInResult {
    case signedIn
    case needsConfirmation
    case signInError(String)
    case resetPassword
}

enum AuthUtilsError : Error {
    case unknownError
    case userNotFound(String)
    case limitExceeded
}

class AuthUtils {

    func sendAuthCode(username: String) async -> (Result<String, Error>) {
        do {
            let result = try await Amplify.Auth.resetPassword(for: username)

                switch result.nextStep {
                case .confirmResetPasswordWithCode(let resetPasswordDetails, _):
                    let confirmationMessage = "Confirmation code sent via \(resetPasswordDetails) to: \(resetPasswordDetails)"
                    print(confirmationMessage)
                    return .success(confirmationMessage)
                default:
                    return .failure(AuthUtilsError.unknownError)
                }
        } catch let error as AWSCognitoAuthError {
                switch error {
                case .userNotFound:
                    return .failure(AuthUtilsError.userNotFound("If you do not know your username for SIMPL Bedside, please contact your program coordinator."))
                default:
                    return .failure(error)
                }
        } catch let error as APIError {
                NSLog("""
                Failed to submit email input for reset password with an Amplify.APIError error: \(error.debugDescription)
                """)
                return .failure(error)
        } catch {
                if Task.isCancelled {
                    NSLog("""
                    Failed to submit email input for reset password with Swift.CancellationError:
                    \(error.localizedDescription)
                    """)
                } else {
                    NSLog("Failed to submit email input for reset password: \(error.localizedDescription)")
                }

                return .failure(error)
            }
    }

    func signIn(userName: String, password: String) async -> SignInResult {
        do {
            NSLog("Invoke Amplify cognito signin.")

            let result = try await Amplify.Auth.signIn(username: userName, password: password)

            guard result.isSignedIn else {
                return .signInError("Not signed-in user.")
            }

            switch result.nextStep {
            case .confirmSignInWithNewPassword:
                return .needsConfirmation
            case .resetPassword:
                return .resetPassword
            case .confirmSignUp:
                return .needsConfirmation
            case .done:
                return .signedIn
            default:
                return .signInError("Unknown Error")
            }
        } catch let error as AuthError {
            return .signInError("AuthError: \(error.localizedDescription)")
        } catch let error as APIError {
            return .signInError("APIError: \(error.localizedDescription)")
        } catch {
            return .signInError("Unknown catch Error: \(error.localizedDescription)")
        }
    }



    func confirmForgotPassword(username: String, newPassword: String, code: String) async -> (Bool, String) {
        do {
            try await Amplify.Auth.confirmResetPassword(for: username, with: newPassword, confirmationCode: code)
            NSLog("Successfully submitted new password.")
            return (true, "Password changed successfully")
        } catch let error as AuthError {
            NSLog("Failed to submit new password input for reset password. \(error.debugDescription)")
            return (false, "Error: Could not change password.")
        } catch let error as APIError {
            NSLog("Failed to submit new password input for reset password with an Amplify.APIError error: \(error.debugDescription)")
            return (false, "Error: Could not change password.")
        } catch {
            if Task.isCancelled {
                NSLog("Failed to submit new password input for reset password with Swift.CancellationError: \(error.localizedDescription)")
            } else {
                NSLog("Failed to submit new password input for reset password: \(error.localizedDescription)")
            }

            return (false, "Error: Could not change password.")
        }
    }

//    //TODO: Make internal type for SignInResult.
//    func confirmSignUp(username: String, confirmationCode: String, completion: @escaping (Result<SignUpResult, Error>)->()) {
//        AWSMobileClient.default().confirmSignUp(username: username, confirmationCode: confirmationCode) { (signUpResult, error) in
//            DispatchQueue.main.async {
//                if let error = error {
//                    completion(.failure(error))
//                } else if let signUpResult = signUpResult {
//                    completion(.success(signUpResult))
//                }
//            }
//        }
//    }

    func confirmSignUp(username: String, confirmationCode: String) async -> Result<Bool, Error>  {
            do {
                let result = try await Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode)

                guard result.isSignUpComplete else {
                    return .success(false)
                }

                return .success(true)
            } catch let error as AuthError {
                NSLog("Failed to confirm account registration. \(error.debugDescription))")
                return .failure(error)
            } catch let error as APIError {
                NSLog("Failed to confirm account registration with an Amplify.APIError error: \(error.debugDescription)")
                return .failure(error)
            } catch {
                if Task.isCancelled {
                    NSLog("Failed to confirm account registration with Swift.CancellationError: \(error.localizedDescription)")
                } else {
                    NSLog("Failed to confirm account registration: \(error.localizedDescription)")
                }

                return .failure(error)
            }
    }

    func resendConfirmationCode(username: String) async -> Result<Bool, Error> {
        do {
            let result = try await Amplify.Auth.resendSignUpCode(for: username)
            NSLog("Resend Account Registration Code succeed: \(result)")
            return .success(true)
        } catch let error as AuthError {
            NSLog("Failed the request resend a code for for register account confirmation. \(error.debugDescription))")

            return .failure(error)
        } catch let error as APIError {
            NSLog("Failed the request resend a code for for register account confirmation with an Amplify.APIError error: \(error.debugDescription)")
            return .failure(error)
        } catch {
            if Task.isCancelled {
                NSLog("Failed the request resend a code for for register account confirmation with Swift.CancellationError: \(error.localizedDescription)")
            } else {
                NSLog("Failed the request resend a code for for register account confirmation: \(error.localizedDescription)")
            }

            return .failure(error)
        }
    }

    func signOut() async {
        NSLog("Signing-out the user.")

        let result = await Amplify.Auth.signOut()

        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "storedProfileImage")

        NSLog("Successfully signed out. \(result)")

        NotificationCenter.default.post(name: TabBarEvents.change, object: Tab.verify)
    }
}


