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
    @Published var organizations : [Organization] = []
    @Published var certificationRecords: [CertificationRecord] = []
    
    
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
            if let e = error {
                print("error in getUserAttributes: \(e.localizedDescription)")
            }
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
                    self.fetchCertRecords(user: self.currentUser!)
                    
                }
            }
        }
    }
    
    func fetchCertRecords(user: User) {
        let api = CertRecordAPI()
        api.getCertRecords(subjectId:user.id) {
            certRecords in
            self.certificationRecords = certRecords
        }
    }
    
    func updateUserPrograms(userItem: UsersByEmailQuery.Data.UsersByEmail.Item) {
        guard let membershipItems = userItem.memberships?.items else {
            print("User has no memberships")
            return
        }
        
        let memberships : [Membership] = membershipItems.compactMap {
            
            var program : Program? = nil
            
            if let programId = $0?.program.id,
                let name = $0?.program.name,
                let orgID = $0?.program.orgId {
                let organization = Organization(id: orgID)
                self.organizations.append(organization)
                program = Program(id: programId, name: name, orgID: orgID, description: $0?.program.description)
            }
            
            if let membershipId = $0?.id,
                let roleString = $0?.role.rawValue,
                let roleModel = RoleModel(rawValue: roleString),
                let prog = program,
                let user = self.currentUser {
                return Membership(id:membershipId, role: roleModel, user: user, program: prog)
            }
            
            return nil
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
