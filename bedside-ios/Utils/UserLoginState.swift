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
            self.fetchUserInfo()
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
                    self.updateUserPrograms(userItem: userItem)
                }
            }
        }
    }
    
    func updateUserPrograms(userItem: UsersByEmailQuery.Data.UsersByEmail.Item) {
        guard let membershipItems = userItem.memberships?.items else {
            print("User has no memberships")
            return
        }
        
        let memberships : [Membership] = membershipItems.compactMap {
            let program = Program(id: ($0?.program.id)!, name: ($0?.program.name)!, orgID: ($0?.program.orgId)!, description: $0?.program.description, memberships: nil)
            return Membership(id: $0!.id, role: RoleModel(rawValue:($0?.role.rawValue)!)!, user: self.currentUser!, program: program)
        }
        
        currentUser?.memberships = memberships
    }
    
    func updateUser(user: User) {
        self.currentUser = user
        let updateUserInput = UpdateUserInput(id: user.id, phone: user.phone, firstName: user.firstName, lastName: user.lastName, npi: user.npi)
        updateUser(updateUserInput)
    }
    
    func updateUser(_ updateUserInput: UpdateUserInput) {
        let mutation = UpdateUserMutation(input: updateUserInput)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        appSyncClient?.perform(mutation: mutation, resultHandler: { (data, error) in
            print("appsync update complete")
        })
    }
    
    init() {
        initializeAWSMobileClient()
        addUserStateListener()
        fetchUserInfo()
    }
}
