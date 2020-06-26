//
//  UserService.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 6/24/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit

enum UserServiceError: Error {
    case unknown
    case noResults
    case apiError(String)
}

extension UserServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("Unknown error in User service.", comment: "Unknown error")
        case .noResults:
            return NSLocalizedString("User service request produced no results.", comment: "No results")
        case .apiError(let error):
            return NSLocalizedString("Error with user service request: \(error)", comment: "API Error")
        }
    }
}

protocol UserService {
    typealias Handler = (Result<[User], UserServiceError>) -> ()
    func fetchUsers(orgId: String, withFilterText filter: String?, completion: @escaping Handler)
}

class AppSyncUserService: UserService {
    func fetchUsers(orgId: String, withFilterText filter: String?, completion: @escaping Handler) {
        if let filter = filter {
            fetchRatersWithFilter(orgId: orgId, filterText: filter, completion: completion)
        } else {
            fetchRaters(orgId: orgId, completion: completion)
        }
    }
    
    func fetchRatersWithFilter(orgId: String, filterText: String, completion: @escaping Handler) {
        let modelIDInput = ModelIDInput(eq: orgId)
        let filterStringInput = ModelStringInput(contains: filterText)
        let firstNameFilter = ModelUserFilterInput(orgId: modelIDInput, firstName: filterStringInput)
        let lastNameFilter = ModelUserFilterInput(orgId: modelIDInput, lastName: filterStringInput)
        let emailFilter = ModelUserFilterInput(orgId: modelIDInput, email: filterStringInput)
        let orFilter = ModelUserFilterInput(or:[firstNameFilter, lastNameFilter, emailFilter])
        fetchUsers(filter: orFilter, completion: completion)
    }
    
    func fetchRaters(orgId: String, completion: @escaping Handler)  {
        let modelIDInput = ModelIDInput(eq: orgId)
        let userFilter = ModelUserFilterInput(orgId: modelIDInput)
        fetchUsers(filter: userFilter, completion: completion)
    }
    
    func fetchUsers(filter: ModelUserFilterInput, nextToken: String? = nil, completion: @escaping Handler, userList: [User] = []) {
        let listUsersQuery = ListUsersQuery(filter: filter, limit: 1000, nextToken: nextToken)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        appSyncClient?.fetch(query: listUsersQuery, cachePolicy: .returnCacheDataAndFetch, resultHandler: {
            [weak self] (result, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                completion(.failure(.apiError(error.localizedDescription)))
                return
            }
            
            if let userItems = result?.data?.listUsers?.items {
                let users = (userItems.compactMap { $0?.mapToUser() } + userList).uniques
                if let next = result?.data?.listUsers?.nextToken {
                    strongSelf.fetchUsers(filter: filter, nextToken: next, completion: completion, userList: users)
                } else {
                    completion(.success(users))
                }
            } else {
                completion(.failure(.noResults))
            }
       })
    }
}
