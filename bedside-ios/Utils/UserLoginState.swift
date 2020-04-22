//
//  LoggedInState.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import AWSMobileClient
import AmplifyPlugins
import Amplify

class UserLoginState: ObservableObject {
    
    @Published var isSignedIn : Bool = false
    @Published var userState : UserState = .unknown
    @Published var currentUser : User?
    
    
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
    
    func initializeAWSMobileClient()  {
        AWSMobileClient.default().initialize { (userState, error) in
            guard error == nil else {
                print("Error initializing AWSMobileClient. Error: \(error!.localizedDescription)")
                return
            }
            
            if let userState = userState {
                self.setIsSignedIn(userState: userState)
                self.userState = userState
            }
        }
    }
    
    func addUserStateListener()  {
        AWSMobileClient.default()
            .addUserStateListener(self) { (userState, info) in
                print("userState change \(userState)")
                DispatchQueue.main.async {
                    self.setIsSignedIn(userState: userState)
                }
        }
    }
    
    func fetchUserInfo() {
        //get logged in user email
        AWSMobileClient.default().getUserAttributes { (attributes, error) in
            if let email = attributes?["email"] {
                self.fetchUserInfo(email: email)
            }
        }
    }
    
    func fetchUserInfo(email: String) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let appSyncClient = appDelegate.appSyncClient
            appSyncClient?.fetch(query:  UsersByEmailQuery(email: email, limit: 1), cachePolicy: .returnCacheDataAndFetch) {
                (result, error ) in
                
                if let userItem = result?.data?.usersByEmail?.items?.compactMap({ $0 }).first {
                    self.currentUser = User(id: userItem.id, userName: userItem.userName, email: userItem.email, phone: userItem.phone, firstName: userItem.firstName, lastName: userItem.lastName, npi: userItem.npi)
                }
            }
        }
    }
    
    init() {
        initializeAWSMobileClient()
        addUserStateListener()
        fetchUserInfo()
    }
}
