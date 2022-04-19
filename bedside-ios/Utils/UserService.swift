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
    typealias Handler = (Result<[User], UserServiceError>) -> ()
    func fetchUsers(orgId: String, withFilterText filter: String?, completion: @escaping Handler)
    func fetchUser(email: String, completion: @escaping Handler)
}

class AppSyncUserService: UserService {
    func fetchUser(email: String, completion: @escaping Handler) {
        fetchUserByEmail(email: email, completion: completion)
    }
    
    func fetchUserByEmail(email: String, nextToken: String? = nil, completion: @escaping Handler, userList: [User] = []) {
        let usersByEmailQuery = UsersByEmailQuery(email: email, limit: 1000, nextToken: nextToken)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncPublicClient = appDelegate.appSyncPublicClient
        appSyncPublicClient?.fetch(query: usersByEmailQuery, resultHandler: {
            [weak self] (result, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                completion(.failure(.apiError(error.localizedDescription)))
                return
            }
            
            if let userItems = result?.data?.usersByEmail?.items {
                let users = (userItems.compactMap { $0.mapToUser() } + userList).uniques
                if let next = result?.data?.usersByEmail?.nextToken {
                    strongSelf.fetchUserByEmail(email: email, nextToken: next, completion: completion, userList: users)
                } else {
                    if(users.count == 0){
                        completion(.failure(.noResults))
                    }
                    else {
                        if ((users.compactMap({ $0 }).first)?.userName != nil){
                            completion(.success(users))
                        }
                        else {
                            completion(.failure(.noAccount))
                        }
                    }
                    
                }
            } else {
                completion(.failure(.noResults))
            }
       })
    }
    
    func fetchUsers(orgId: String, withFilterText filter: String?, completion: @escaping Handler) {
            fetchRaters(orgId: orgId, completion: completion)
    }
    
    func fetchRaters(orgId: String, completion: @escaping Handler)  {
        let modelIDInput = ModelIDInput(eq: orgId)
        let userFilter = ModelUserFilterInput(orgId: modelIDInput)
        fetchUsers(filter: userFilter, completion: completion)
        
    }
    
    func fetchUsers(filter: ModelUserFilterInput, nextToken: String? = nil, completion: @escaping Handler, userList: [User] = []) {
        let listUsersQuery = ListUsersQuery(filter: filter, limit: 1000, nextToken: nextToken)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncPrivateClient = appDelegate.appSyncPrivateClient
        appSyncPrivateClient?.fetch(query: listUsersQuery, cachePolicy: .returnCacheDataAndFetch, resultHandler: {
            [weak self] (result, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                completion(.failure(.apiError(error.localizedDescription)))
                return
            }
            
            if let userItems = result?.data?.listUsers?.items {
                let users = (userItems.compactMap { $0.mapToUser() } + userList).uniques
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
