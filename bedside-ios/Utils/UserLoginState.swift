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
import Combine



class UserLoginState: ObservableObject {
    
    @Published var isSignedIn : Bool = false
    @Published var userState : UserState = .unknown
    @Published var currentUser : User?
    @Published var organizations : [Organization] = []
    @Published var certRecordViewModel: CertRecordViewModel = CertRecordViewModel()
    @Published var ratersViewModel: RatersViewModel = RatersViewModel()
    @Published var procedureSelectViewModel: ProcedureSelectViewModel = ProcedureSelectViewModel()
    
    //TODO: have intermediate states for loading user data to display intermediate UIs
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
            if error != nil {
                print("User is not signed in, cannot fetch user attributes")
                let email = UserDefaults.standard.string(forKey: "userEmail")
                self.fetchUserInfo(email: email ?? "")
            }
            if let email = attributes?["email"] {
                self.fetchUserInfo(email: email)
                UserDefaults.standard.set(email, forKey: "userEmail")
            }
        }
    }
    
    func fetchUserInfo(email: String) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let appSyncPrivateClient = appDelegate.appSyncPrivateClient
            appSyncPrivateClient?.fetch(query:  UsersByEmailQuery(email: email, limit: 1), cachePolicy: .returnCacheDataAndFetch) {
                (result, error ) in
                
                if let userItem = result?.data?.usersByEmail?.items.compactMap({ $0 }).first {
                    self.currentUser = userItem.mapToUser()
                    self.fetchProcedures()
                    self.fetchRaters(user: self.currentUser!)
                    self.updateUserPrograms(userItem: userItem)
                    self.fetchCertRecords(user: self.currentUser!)
                }
            }
        }
    }
    
    func fetchProcedures(){
        guard let currentUser = self.currentUser else { return }
        self.procedureSelectViewModel.fetchProcedures(user: currentUser)
    }
    
    func fetchRaters(user: User){
        self.ratersViewModel.fetchRaters(orgId: user.orgId!)
    }
    
    func fetchCertRecords(user: User){
        self.certRecordViewModel.fetchCertRecords(user: user)
    }
    
    func fetchCurrentUserCertRecords() {
        guard let currentUser = self.currentUser else { return }
        fetchCertRecords(user: currentUser)
    }
    
    func fetchOrganizationInfo(orgId: String) {

        for org in self.organizations {
            if (org.id == orgId) {
                return
            }
        }
        
        let getOrgQuery = GetOrganizationQuery(id: orgId)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncPrivateClient = appDelegate.appSyncPrivateClient
        appSyncPrivateClient?.fetch(query: getOrgQuery, cachePolicy: .returnCacheDataAndFetch, resultHandler: { (data, err) in
            guard let results = data?.data?.getOrganization else {
                print("error fetching organzation info: \(String(describing: err))")
                return
            }
            
            let programs = results.programs?.items.compactMap({ (item) -> Program? in
                return Program(id: item.id, name: item.name, orgID: item.orgId, description: item.description)
            })
            
            let org = Organization(id: results.id, title: results.title, description: results.description, programs: programs)
            
            self.organizations.removeAll()
            self.organizations.append(org)
        })
    }
    
    func updateUserPrograms(userItem: UsersByEmailQuery.Data.UsersByEmail.Item) {
        guard let membershipItems = userItem.memberships?.items else {
            print("User has no memberships")
            return
        }
        
        let orgIds : Set<String> = []
        
        let memberships : [Membership] = membershipItems.compactMap {
            
            let program : Program? = Program(id: $0.program.id, name: $0.program.name, orgID: $0.program.orgId, description: $0.program.description)
            
            
            if  let prog = program,
                let user = self.currentUser {
                let roleModel = RoleModel(rawValue: $0.role.rawValue) ?? RoleModel(rawValue: "User")
                return Membership(id:$0.id, role: roleModel!, user: user, program: prog)
            }
            
            return nil
        }
        
        let _ = orgIds.map { (orgId) in
            fetchOrganizationInfo(orgId: orgId)
        }
        
        currentUser?.memberships = memberships
    }
    
    func updateUser(user: User, completion: @escaping (Result<User?, Error>)->()) {
        let updateUserInput = UpdateUserInput(id: user.id, phone: user.phone, firstName: user.firstName, lastName: user.lastName, npi: user.npi)
        updateUser(updateUserInput, completion: completion)
    }
    
    func updateUser(_ updateUserInput: UpdateUserInput, completion: @escaping (Result<User?, Error>)->()) {
        let mutation = UpdateUserMutation(input: updateUserInput)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncPrivateClient = appDelegate.appSyncPrivateClient
        appSyncPrivateClient?.perform(mutation: mutation, resultHandler: { (data, error) in
            if let error = error {
                completion(.failure(error))
            } else if let userItem = data?.data?.updateUser  {
                self.currentUser = userItem.mapToUser()
                completion(.success(self.currentUser))
            } else {
                completion(.success(nil))
            }
        })
    }
    
    var cancelableSet : Set<AnyCancellable> = []
    
    init() {
        initializeAWSMobileClient()
        addUserStateListener()
        NotificationCenter.default
            .publisher(for: Notification.Name("Refresh.CertRecords"))
            .sink { (notification) in
                self.fetchCurrentUserCertRecords()
            }
            .store(in: &cancelableSet)
    }
}
