//
//  UserService.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 6/24/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit
import Amplify
import AWSPluginsCore

enum UserServiceError: Error {
    case unknown
    case noResults
    case noAccount
    case apiError(String)
}

extension UserServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("Unknown error in User service.", comment: "Unknown error")
        case .noResults:
            return NSLocalizedString("User service request produced no results.", comment: "No results")
        case .noAccount:
            return NSLocalizedString("User service request produced no results.", comment: "No results")
        case .apiError(let error):
            return NSLocalizedString("Error with user service request: \(error)", comment: "API Error")
        }
    }
}

protocol UserService {
//    typealias Handler = (Result<[User], UserServiceError>) -> ()
    func fetchUsers(orgId: String, withFilterText filter: String?) async -> Result<[User], UserServiceError>
    func fetchUser(email: String) async -> Result<[User], UserServiceError>
}

class AppSyncUserService: UserService {

    func fetchUser(email: String) async -> Result<[User], UserServiceError> {
        return await fetchUserByEmail(email: email)
    }

    func fetchUserByEmail(email: String, nextToken: String? = nil, userList: [User] = []) async -> Result<[User], UserServiceError> {
        while true {
            let request = buildUsersByEmailQuery(email: email, nextToken: nextToken)

            do {
                let result = try await Amplify.API.query(request: request)

                switch result {
                case .success(let record):
                    var updatingUsersList = userList
                    updatingUsersList.append(contentsOf: record.items)

                    guard let nextToken = record.nextToken else {
                        if(updatingUsersList.count == 0){
                            return .failure(.noResults)
                        }
                        else {
                            if ((updatingUsersList.compactMap({ $0 }).first)?.userName != nil){
                                return .success(updatingUsersList)
                            }
                            else {
                                return .failure(.noAccount)
                            }
                        }
                    }

                    return await fetchUserByEmail(email: email, nextToken: nextToken, userList: updatingUsersList)
                case .failure(let error):
                    NSLog("Retrieve batch of UsersByEmail failed: \(error.debugDescription)")
                    return .failure(.apiError(error.localizedDescription))
                }
            } catch let error as APIError {
                NSLog("Retrieve batch of UsersByEmail failed: \(error.debugDescription)")
                return .failure(.apiError(error.localizedDescription))
            } catch {
                if Task.isCancelled {
                    NSLog("Retrieve batch of UsersByEmail failed with Swift.CancellationError: \(error.localizedDescription)")
                    return .failure(.apiError(error.localizedDescription))
                } else {
                    NSLog("Retrieve batch of UsersByEmail failed: \(error.localizedDescription)")
                    return .failure(.apiError(error.localizedDescription))
                }
            }
        }
    }

    func fetchUsers(orgId: String, withFilterText filter: String?) async -> Result<[User], UserServiceError> {
        return await fetchUsers(orgId: orgId, nextToken: nil, userList: [])
    }

    func fetchUsers(orgId: String, nextToken: String? = nil, userList: [User] = []) async -> Result<[User], UserServiceError>  {
        while true {
            let request = buildListUsersQuery(orgId: orgId, nextToken: nextToken)

            do {
                let result = try await Amplify.API.query(request: request)

                switch result {
                case .success(let record):
                    NSLog("Retrieve batch of ListUsers succeed. \(record)")

                    var updatingUsersList = userList
                    updatingUsersList.append(contentsOf: record.items)

                    guard let nextToken = record.nextToken else {
                        if updatingUsersList.count == 0 {
                            return .failure(.noResults)
                        } else {
                            return .success(updatingUsersList)
                        }
                    }

                    return await fetchUsers(orgId: orgId, nextToken: nextToken, userList: updatingUsersList)
                case .failure(let error):
                    NSLog("Retrieve batch of ListUsers failed: \(error.debugDescription)")
                    return .failure(.apiError(error.localizedDescription))
                }
            } catch let error as APIError {
                NSLog("Retrieve batch of ListUsers failed: \(error.debugDescription)")
                return .failure(.apiError(error.localizedDescription))
            } catch {
                if Task.isCancelled {
                    NSLog("Retrieve batch of ListUsers failed with Swift.CancellationError: \(error.localizedDescription)")
                    return .failure(.apiError(error.localizedDescription))
                } else {
                    NSLog("Retrieve batch of ListUsers failed: \(error.localizedDescription)")
                    return .failure(.apiError(error.localizedDescription))
                }
            }
        }
    }
}

extension AppSyncUserService {

    private func buildListUsersQuery(orgId: String, nextToken: String?) -> GraphQLRequest<UsersList> {

        let formattedOrgId = #"""# + orgId + #"""#

        var argumentValues = "limit: $limit"
        if let nextToken = nextToken {
            argumentValues += ", nextToken: " + #"""# + nextToken + #"""#
        }

        argumentValues += ", filter: {orgID: {eq: \(formattedOrgId)}}"

        let query = """
        query ListUsers($limit: Int) {
            listUsers(\(argumentValues)) {
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
            variables: ["limit": 1000],
            responseType: UsersList.self,
            decodePath: "listUsers"
        )
    }

    private func buildUsersByEmailQuery(email: String, nextToken: String?) -> GraphQLRequest<UsersList> {

        let formattedEmail = #"""# + email + #"""#

        var argumentValues = "limit: $limit, email: \(formattedEmail)"
        if let nextToken = nextToken {
            argumentValues += ", nextToken: " + #"""# + nextToken + #"""#
        }

        let query = """
        query UsersByEmail($limit: Int) {
           usersByEmail(\(argumentValues)) {
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

        let authType = GraphQLRequest<UsersList>.Options(
            pluginOptions: AWSAPIPluginDataStoreOptions(authType: .apiKey, modelName: UsersList.modelName)
        )

        return GraphQLRequest(
            document: query,
            variables: ["limit": 1000],
            responseType: UsersList.self,
            decodePath: "usersByEmail",
            options: authType
        )
    }
}

extension AppSyncUserService {
    class UsersList: Model {
        let items: [User]
        let nextToken: String?
    }
}
