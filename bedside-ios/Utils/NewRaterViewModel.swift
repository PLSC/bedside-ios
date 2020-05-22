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

class NewRaterViewModel: ObservableObject {
    @Published var firstName : String = ""
    @Published var lastName : String = ""
    @Published var email : String = ""
    @Published var selectedProgram : Int = 0
    @Published var programs: [Program]
    var orgId : String
    
    var emailAvailable : AnyPublisher<Bool, Never> {
        return $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { email in
                return Future { promise in
                    self.emailAvailable(email) { available in
                        promise(.success(available))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    var emailValid : AnyPublisher<Bool, Never> {
        return $email
            .filter { email in
                return email.count > 3
            }
            .map { email in
                return email.validateEmail()
            }.eraseToAnyPublisher()
    }
    
    var emailError : AnyPublisher<String?, Never> {
        return Publishers.CombineLatest(emailAvailable, emailValid)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map {available, valid in
                if !valid {return "Email not valid"}
                if !available {return "Email not available"}
                return nil
            }
            .eraseToAnyPublisher()
    }
    
    var userCreatedCallback : (User) -> ()
    
    init(programs:[Program],
         orgId: String,
         userCreatedCallback: @escaping (User) -> ()) {
        self.programs = programs
        self.userCreatedCallback = userCreatedCallback
        self.orgId = orgId
    }
    
    var isValid : Bool {
        return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && email.validateEmail()
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
            completion(items.count == 0)
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
        
        guard isValid else {
            callback(NewRaterError.InvalidData)
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        let createUserInput = CreateUserInput(orgId: self.orgId, email: self.email, firstName: self.firstName, lastName: self.lastName, isRater: true)
        let createUserMutation = CreateUserMutation(input: createUserInput)
        appSyncClient?.perform(mutation: createUserMutation, resultHandler: { (data, error) in
            guard let result = data?.data?.createUser else {
                print("error creating rater")
                return
            }

            print("rater created")
            let rater = User(id: result.id,
                             email: result.email,
                             firstName: result.firstName,
                             lastName: result.lastName,
                             orgId: self.orgId )
            self.createMembership(user: rater,
                                  programId: self.programs[self.selectedProgram].id,
                                  callback: callback)
        })
    }
    
}
