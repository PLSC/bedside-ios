//
//  NewRaterViewModel.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/12/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit

class NewRaterViewModel: ObservableObject {
    @Published var firstName : String = ""
    @Published var lastName : String = ""
    @Published var email : String = ""
    @Published var selectedProgram : Int = 0
    @Published var programs: [Program]
    var userCreatedCallback : (User) -> ()
    
    init(programs:[Program],
         userCreatedCallback: @escaping (User) -> ()) {
        self.programs = programs
        self.userCreatedCallback = userCreatedCallback
    }
    
    var isValid : Bool {
        return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty
    }
    
    func submit() {
        guard isValid else {
            return
        }
    }
    
    func createMembership(user: User, programId: String, callback: @escaping ()->()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        
        let createMembershipInput = CreateMembershipInput(role: .user, userId: user.id, programId: programId)
        let createMembershipMutation = CreateMembershipMutation(input: createMembershipInput)
        
        appSyncClient?.perform(mutation: createMembershipMutation, resultHandler: { (result, err) in
            print("Success")
            self.userCreatedCallback(user)
            callback()
        })
    }
    
    func submitNewRater(callback: @escaping () -> ()) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        let createUserInput = CreateUserInput(email: self.email, firstName: self.firstName, lastName: self.lastName, isRater: true)
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
                             lastName: result.lastName)
            self.createMembership(user: rater,
                                  programId: self.programs[self.selectedProgram].id,
                                  callback: callback)
        })
    }
    
}
