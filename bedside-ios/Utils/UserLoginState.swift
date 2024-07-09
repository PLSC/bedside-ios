//
//  LoggedInState.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 2/28/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import Amplify
import Combine



class UserLoginState: ObservableObject {

    @Published var isSignedIn : Bool?
    @Published var currentUser : User?
    @Published var organizations : [Organization] = []
    @Published var certRecordViewModel: CertRecordViewModel = CertRecordViewModel()
    @Published var ratersViewModel: RatersViewModel = RatersViewModel()
    @Published var procedureSelectViewModel: ProcedureSelectViewModel = ProcedureSelectViewModel()
    
    //TODO: have intermediate states for loading user data to display intermediate UIs

    func validateCurrentAuthSession() async {
        do {
            NSLog("Validating user auth session.")

            let session = try await Amplify.Auth.fetchAuthSession(options: .forceRefresh())

            NSLog("Validating user auth session completed")

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                self.isSignedIn = session.isSignedIn
            }

            if session.isSignedIn {
                await self.fetchUserInfo()
            }
        } catch let error as AuthError {
            NSLog("Fetch user auth session failed with error \(error)")

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.isSignedIn = false
            }
        } catch let error as APIError {
            NSLog("Fetch user auth session failed with an Amplify.APIError error: \(error.debugDescription)")

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.isSignedIn = false
            }
        } catch {
            if Task.isCancelled {
                NSLog("Fetch user auth session failed with Swift.CancellationError: \(error.localizedDescription)")
            } else {
                NSLog("Fetch user auth session failed: \(error)")
            }

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.isSignedIn = false
            }
        }
    }


    func fetchUserInfo() async {
        do {
            let attributes = try await Amplify.Auth.fetchUserAttributes()
            print("User attributes - \(attributes)")

            if let email = findValueForKey(.email, in: attributes) {
                await self.fetchUserInfo(email: email)
                UserDefaults.standard.set(email, forKey: "userEmail")
            }

        } catch let error as AuthError{
            print("Fetching user attributes failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    func fetchUserInfo(email: String) async {
        let request = buildUsersByEmailQuery(email: email)

        do {
            let result = try await Amplify.API.query(request: request)

            switch result {
            case .success(let usersRecord):
                guard let user = usersRecord.first else {
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }

                    self.currentUser = user

                    Task {
                        await self.fetchProcedures()
                        await self.fetchRaters(user: self.currentUser!)
                        self.updateUserPrograms(userItem: user)
                        await self.fetchCertRecords(user: self.currentUser!)
                    }
                }
            case .failure(let error):
                NSLog("Fetching list of users by the usersByEmailLower was failed with a Amplify.GraphQLResponseError<%@> error %@.", User.modelName, error.debugDescription)
            }
        } catch let error as GraphQLResponseError<[User]> {
            NSLog("Fetching list of users by the usersByEmailLower was failed with a Amplify.GraphQLResponseError<%@> error %@.", User.modelName, error.debugDescription)
        } catch let error as APIError {
            NSLog(
                "Fetching list of users by the usersByEmailLower was failed with an Amplify.APIError<%@> error %@.",
                User.modelName, error.debugDescription
            )

            switch error {
            case .networkError:
                NSLog("Has gotten networkError for the usersByEmailLower lambda")
            default:
                break
            }
        } catch {
            if Task.isCancelled {
                NSLog("usersByEmailLowerQuery lambda failed with Swift.CancellationError: \(error.localizedDescription)")
            } else {
                NSLog("usersByEmailLowerQuery lambda failed: \(error)")
            }
        }
    }

    func fetchProcedures() async {
        guard let currentUser = self.currentUser else { return }

        await self.procedureSelectViewModel.fetchProcedures(user: currentUser)
    }
    
    func fetchRaters(user: User) async {
        await self.ratersViewModel.fetchRaters(orgId: user.orgID!)
    }
    
    func fetchCertRecords(user: User) async {
        await self.certRecordViewModel.fetchCertRecords(user: user)
    }
    
    func fetchCurrentUserCertRecords()async {
        guard let currentUser = self.currentUser else {
            await fetchUserInfo()
            return
        }
        await fetchCertRecords(user: currentUser)
    }

    func fetchOrganizationInfo(orgId: String) async {
        let request = buildGetOrganizationQuery(orgId: orgId)

        do {
            let result = try await Amplify.API.query(request: request)

            switch result {
            case .success(let orgRecord):
                NSLog("Retrieving the organization with the id: \(orgId) was succeeded.")

                self.organizations.removeAll()
                self.organizations.append(orgRecord)
            case .failure(let error):
                NSLog("Retrieving the organization with the id: \(orgId) was failed with a Amplify.GraphQLResponseError<%@> error %@.", Organization.modelName, error.debugDescription)
            }
        } catch let error as GraphQLResponseError<Organization> {
            NSLog("Retrieving the organization with the id: \(orgId) was failed with a Amplify.GraphQLResponseError<%@> error %@.", Organization.modelName, error.debugDescription)
        } catch let error as APIError {
            NSLog(
                "Retrieving the organization with the id: \(orgId) was failed with an Amplify.APIError<%@> error %@.",
                Organization.modelName, error.debugDescription
            )
        } catch {
            if Task.isCancelled {
                NSLog("getorgId lambda failed with Swift.CancellationError: \(error.localizedDescription)")
            } else {
                NSLog("getorgId lambda failed: \(error)")
            }
        }
    }

    func updateUserPrograms(userItem: User) {
        guard let membershipItems = userItem.memberships else {
            print("User has no memberships")
            return
        }

        let orgIds : Set<String> = []

        let memberships : [Membership] = membershipItems.compactMap {

            let program : Program? = Program(id: $0.program.id, name: $0.program.name, orgID: $0.program.orgID, description: $0.program.description)


            if  let prog = program,
                let user = self.currentUser {
                let roleModel = Role(rawValue: $0.role.rawValue) ?? Role(rawValue: "User")
                return Membership(id:$0.id, role: roleModel!, user: user, program: prog)
            }

            return nil
        }

        let _ = orgIds.map { (orgId) in
            Task {
                await fetchOrganizationInfo(orgId: orgId)
            }
        }

        currentUser?.memberships = List(elements: memberships)
    }

    func updateUser(user: User) async -> Result<User?, Error> {
        let mutation = buildUpdateUserMutation(user: user)

        let request = GraphQLRequest(document: mutation, responseType: User.self, decodePath: "updateUser")

        do {
            let result = try await Amplify.API.mutate(request: request)

            switch result {
            case .success(let user):
                NSLog("Update user with id: \(user.id) with updated profile info succeed.")
                return .success(user)
            case .failure(let error):
                NSLog("Update user with id: \(user.id) with updated profile info failed. error: \(error.debugDescription)")
                return .failure(error)
            }
        } catch let error as GraphQLResponseError<User> {
            NSLog("Update user with id: \(user.id) with updated profile info failed. GraphQLResponseError: \(error.debugDescription)")
            return .failure(error)
        } catch let error as APIError {
            NSLog("Update user with id: \(user.id) with updated profile info failed. Amplify.APIError: \(error.debugDescription)")
            return .failure(error)
        } catch {
            if Task.isCancelled {
                NSLog("Update user mutation failed with Swift.CancellationError: \(error.localizedDescription)")
            } else {
                NSLog("Update user mutation failed: \(error)")
            }

            return .failure(error)
        }
    }

    private func findValueForKey(_ key: AuthUserAttributeKey, in attributes: [AuthUserAttribute]) -> String? {
        for attribute in attributes {
            if attribute.key == key {
                return attribute.value
            }
        }
        return nil
    }

    var cancelableSet : Set<AnyCancellable> = []
    
    init() {
        Task {
            await validateCurrentAuthSession()
        }
        NotificationCenter.default
            .publisher(for: Notification.Name("Refresh.CertRecords"))
            .sink { (notification) in
                Task {
                    await self.fetchCurrentUserCertRecords()
                }
            }
            .store(in: &cancelableSet)
    }
}

extension UserLoginState {

    private func buildGetOrganizationQuery(orgId: String) -> GraphQLRequest<Organization> {

        let formattedOrgId = #"""# + orgId + #"""#

        let query = """
        query GetOrganization {
            getOrganization(id: \(formattedOrgId)) {
                __typename
                id
                title
                description
                programs {
                    __typename
                    items {
                        __typename
                        id
                        name
                        orgID
                        description
                        memberships {
                            __typename
                            items {
                                __typename
                                id
                                role
                                userId
                                programId
                                createdAt
                                updatedAt
                            }
                            nextToken
                        }
                        createdAt
                        updatedAt
                    }
                    nextToken
                }
                createdAt
                updatedAt
            }
        }
        """

        return GraphQLRequest(
            document: query,
            responseType: Organization.self,
            decodePath: "getOrganization"
        )
    }

    private func buildUpdateUserMutation(user: User) -> String {
        let userIdQuery = "id: " + #"""# + user.id + #"""#
        let firstNameQuery = " , firstName: " + getOptionalString(optionalString: user.firstName)
        let lastNameQuery = " , lastName: " + getOptionalString(optionalString: user.lastName)
        let input = "input: {" + userIdQuery + firstNameQuery + lastNameQuery + "}"

        return """
            mutation UpdateUser {
                updateUser(\(input)) {
                    id
                    orgID
                    firstName
                    lastName
                    email
                    userName
                }
            }
            """
    }

    private func getOptionalString(optionalString: String?) -> String {
        var stringValue = "null"

        if let optionalString = optionalString, !optionalString.isEmpty {
            stringValue = #"""# + optionalString + #"""#
        }

        return stringValue
    }

    private func buildUsersByEmailQuery(email: String) -> GraphQLRequest<[User]> {

        let formattedEmail = #"""# + email + #"""#

        let query = """
        query UsersByEmail($limit: Int) {
           usersByEmail(email: \(formattedEmail), limit: $limit) {
                __typename
                items {
                    __typename
                    id
                    orgID
                    userName
                    email
                    phone
                    firstName
                    lastName
                    npi
                    pgy
                    isRater
                    memberships {
                        __typename
                        items {
                            __typename
                            id
                            role
                            userId
                            user {
                                __typename
                                id
                                orgID
                                userName
                                email
                                phone
                                firstName
                                lastName
                                npi
                                pgy
                                isRater
                                createdAt
                                updatedAt
                            }
                            programId
                            program {
                                __typename
                                id
                                name
                                orgID
                                description
                                createdAt
                                updatedAt
                            }
                            createdAt
                            updatedAt
                        }
                        nextToken
                    }
                    createdAt
                    updatedAt
                }
                nextToken
           }
         }
        """

        return GraphQLRequest(
            document: query,
            variables: ["limit": 1],
            responseType: [User].self,
            decodePath: "usersByEmail.items"
        )
    }
}
