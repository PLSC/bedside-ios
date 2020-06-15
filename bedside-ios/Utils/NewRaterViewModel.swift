//
//  NewRaterViewModel.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/12/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit
import Combine

enum NewRaterError: Error {
    case InvalidData
}

//TODO: Inject a new user API module instead of embedding.
class NewRaterViewModel: ObservableObject {
    @Published var firstName : String = ""
    @Published var lastName : String = ""
    @Published var email : String = ""
    @Published var programs: [Program]
    
    @Published var emailErrorMessage : String? = nil
    @Published var emailValid : Bool = false
    @Published var emailAvailable: Bool = false
    @Published var isRaterValid : Bool = false
    
    @Published var reccomendedUser : User? = nil
    
    var orgId : String
    private var cancellableSet : Set<AnyCancellable> = []
    
    var userCreatedCallback : (User) -> ()
    
    func selectReccomendedUser() {
        guard let user = reccomendedUser else { return }
        userCreatedCallback(user)
    }
    
    init(programs:[Program],
         orgId: String,
         userCreatedCallback: @escaping (User) -> ()) {
        self.programs = programs
        self.userCreatedCallback = userCreatedCallback
        self.orgId = orgId
        
        $email.receive(on: RunLoop.main).map { email in
            return email.count > 3 && email.validateEmail()
        }
        .assign(to: \.emailValid, on: self)
        .store(in: &cancellableSet)
        
        $emailValid
            .receive(on: RunLoop.main)
            .flatMap { valid in
                return Future { promise in
                    if valid {
                        self.emailAvailable(self.email) { available in
                            promise(.success(available))
                        }
                    } else {
                        promise(.success(false))
                    }
                }
            }
            .assign(to: \.emailAvailable, on: self)
            .store(in: &cancellableSet)
        
        
        Publishers.CombineLatest3($emailAvailable, $firstName, $lastName)
            .receive(on: RunLoop .main)
            .map { emailAvailable, firstName, lastName in
                return emailAvailable && !firstName.isEmpty && !lastName.isEmpty
            }
            .assign(to: \.isRaterValid, on: self)
            .store(in: &cancellableSet)
        
        Publishers.CombineLatest3($emailAvailable, $emailValid, $email)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { available, valid, email in
                if email.count < 4 { return nil }
                if !valid {return "Email not valid"}
                if !available {return "Email not available"}
                return nil
            }
            .assign(to: \.emailErrorMessage, on: self)
            .store(in: &cancellableSet)
        
        $reccomendedUser.receive(on: RunLoop.main)
            .sink { user in
                print("reccomended user: \(String(describing: user?.displayName))")
            }
            .store(in: &cancellableSet)
    }
        
    func emailAvailable(_ email: String, completion: @escaping (Bool) -> ()) {
        let usersByEmailQuery = UsersByEmailQuery(email: email)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        appSyncClient?.fetch(query: usersByEmailQuery, cachePolicy:.fetchIgnoringCacheData, resultHandler: { (result, error) in
            guard let items = result?.data?.usersByEmail?.items else {
                completion(false)
                return
            }
            let noUser = items.count == 0
            completion(noUser)
            if let userItem = items.first {
                //Assign reccomended user
                self.reccomendedUser = userItem?.mapToUser()
            } else {
                self.reccomendedUser = nil
            }
        })
    }
    
    func createMembership(user: User, programId: String, callback: @escaping (Error?)->()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        
        let createMembershipInput = CreateMembershipInput(role: .user, userId: user.id, programId: programId)
        let createMembershipMutation = CreateMembershipMutation(input: createMembershipInput)
        
        appSyncClient?.perform(mutation: createMembershipMutation, resultHandler: { (result, err) in
            guard err == nil else {
                callback(err)
                return
            }
            
            self.userCreatedCallback(user)
            callback(err)
        })
    }
    
    func submitNewRater(callback: @escaping (Error?) -> ()) {
        
        guard isRaterValid else {
            callback(NewRaterError.InvalidData)
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        let createUserInput = CreateUserInput(orgId: self.orgId, email: self.email, firstName: self.firstName, lastName: self.lastName, isRater: true)
        let createUserMutation = CreateUserMutation(input: createUserInput)
        appSyncClient?.perform(mutation: createUserMutation, resultHandler: { (response, error) in
            guard let result = response?.data?.createUser else {
                print("error creating rater")
                callback(error)
                return
            }

            print("rater created")
            let rater = User(id: result.id,
                             email: result.email,
                             firstName: result.firstName,
                             lastName: result.lastName,
                             orgId: self.orgId )
           
            self.userCreatedCallback(rater)
            callback(error)
        })
    }
    
}
