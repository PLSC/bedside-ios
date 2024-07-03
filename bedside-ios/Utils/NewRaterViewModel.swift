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
import Amplify

enum NewRaterError: Error {
    case InvalidData
}

//TODO: Inject a new user API module instead of embedding.
class NewRaterViewModel: ObservableObject {
    @Published var firstName : String = ""
    @Published var lastName : String = ""
    @Published var email : String = ""
    
    @Published var emailErrorMessage : String? = nil
    @Published var emailValid : Bool = false
    @Published var emailAvailable: Bool = false
    @Published var isRaterValid : Bool = false
    
    @Published var recommendedUser : User? = nil

    let userService = AppSyncUserService()

    var orgId : String
    private var cancellableSet : Set<AnyCancellable> = []
    var currentUser : User?
    
    var userCreatedCallback : (User) -> ()
    
    func selectReccomendedUser() {
        guard let user = recommendedUser else { return }
        userCreatedCallback(user)
    }
    
    init(orgId: String,
         currentUser: User?,
         userCreatedCallback: @escaping (User) -> ()) {
        
        self.userCreatedCallback = userCreatedCallback
        self.orgId = orgId
        self.currentUser = currentUser
        
        $email.receive(on: RunLoop.main)
            .map { email in
                return email.count > 3 && email.validateEmail() && !(email == currentUser?.email)
            }
            .assign(to: \.emailValid, on: self)
            .store(in: &cancellableSet)
        
        $emailValid
            .receive(on: RunLoop.main)
            .flatMap { valid in
                return Future { promise in
                    if valid {
                        Task {
                            let available = await self.emailAvailable(self.email)

                            DispatchQueue.main.async {
                                promise(.success(available))
                            }
                        }
//                        self.emailAvailable(self.email) { available in
//                            promise(.success(available))
//                        }
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
                if !available {return "User already exists"}
                return nil
            }
            .assign(to: \.emailErrorMessage, on: self)
            .store(in: &cancellableSet)
    }


    func emailAvailable(_ email: String) async -> Bool {

        let result = await userService.fetchUser(email: email)

        switch result {
        case .success(let usersRecord):
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                if let userItem = usersRecord.first {
                    //Assign reccomended user
                    self.recommendedUser = userItem
                } else {
                    self.recommendedUser = nil
                }
            }

            return usersRecord.count == 0
        case .failure:
            return true
        }
    }

    func submitNewRater() async -> Error? {

        guard isRaterValid else {
            return NewRaterError.InvalidData
        }

        let rater = User(orgID: self.orgId,
                         email: self.email,
                         firstName: self.firstName,
                         lastName: self.lastName,
                         isRater: true)

        do {
            let result = try await Amplify.API.mutate(request: .create(rater))

            switch result {
            case .success(let record):
                NSLog("Creating a rater was succeeded. New record identifier: %@", record.identifier)
                return nil
            case .failure(let error):
                NSLog("Creating a rater was failed with a Amplify.GraphQLResponseError<User> error %@.", error.debugDescription)

                return error
            }
        } catch let error as GraphQLResponseError<User> {
            NSLog("Creating a rater was failed with a Amplify.GraphQLResponseError<User> error %@.", error.debugDescription)

            return error
        } catch let error as APIError {
            NSLog("Creating a rater was failed with an Amplify.APIError<User> error %@.", error.debugDescription)

            return error
        } catch {
            if Task.isCancelled {
                NSLog("add record query failed with Swift.CancellationError: \(error.localizedDescription)")
                return nil
            } else {
                NSLog("add rater record query failed: \(error)")
                return error
            }
        }

//        let mutation = buildCreateUserMutation(orgId: self.orgId, email: self.email, firstName: self.firstName, lastName: self.lastName, isRater: true)
//
//        let request = GraphQLRequest(document: mutation, responseType: User.self, decodePath: "createUser")
//
//        do {
//            let result = try await Amplify.API.mutate(request: request)
//
//            switch result {
//            case .success(let user):
//                print("rater created")
//                let rater = User(id: user.id,
//                                 orgID: self.orgId,
//                                 userName: user.userName,
//                                 email: user.email,
//                                 phone: user.phone,
//                                 firstName: user.firstName,
//                                 lastName: user.lastName)
//
//                self.userCreatedCallback(rater)
//
//                return nil
//            case .failure(let error):
//                NSLog("Create user with email: \(self.email) failed. error: \(error.debugDescription)")
//                return error
//            }
//        } catch let error as GraphQLResponseError<User> {
//            NSLog("Create user with email: \(self.email) failed. GraphQLResponseError: \(error.debugDescription)")
//            return error
//        } catch let error as APIError {
//            NSLog("Create user with email: \(self.email) failed. Amplify.APIError: \(error.debugDescription)")
//            return error
//        } catch {
//            if Task.isCancelled {
//                NSLog("Create user mutation failed with Swift.CancellationError: \(error.localizedDescription)")
//            } else {
//                NSLog("Create user mutation failed: \(error)")
//            }
//
//            return error
//        }
    }

}

//extension NewRaterViewModel {
//
//    private func buildCreateMembershipMutation(role: Role, userId: String, programId: String) -> String {
//        let role = "role: " + role.rawValue
//        let userId = " , userId: " + userId
//        let programId = " , programId: " + programId
//
//        let input = "input: {" + role + userId + programId + "}"
//
//        return """
//            mutation CreateMembership {
//                createMembership(\(input)) {
//                    role
//                    userId
//                    programId
//                }
//            }
//            """
//    }

//    private func buildCreateUserMutation(orgId: String, email: String, firstName: String, lastName: String, isRater: Bool) -> GraphQLRequest<User> {
//        let orgId = "orgId: " + #"""# + orgId + #"""#
//        let email = " , email: " + #"""# + email + #"""#
//        let firstName = " , firstName: " + #"""# + firstName + #"""#
//        let lastName = " , lastName: " + #"""# + lastName + #"""#
//        let isRater = " , isRater: " + "\(isRater)"
//
//        let input = "input: {" + orgId + email + firstName + lastName + isRater + "}"
//
//        let mutation = """
//            mutation CreateUser {
//                createUser(\(input)) {
//                    id
//                    orgId
//                    email
//                    firstName
//                    lastName
//                    isRater
//                }
//            }
//            """
//
//        return GraphQLRequest<User> (
//            document: mutation,
//            responseType: User.self,
//            decodePath: "createUser"
//        )
//    }
//}
