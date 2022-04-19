//
//  UserLoader.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 6/9/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit


enum UserLoaderError : Error {
    case UnknownError
}

/*
 TODO: Work in progress
 */
class UserLoader {
    typealias Handler = (Result<User, Error>) -> Void
    
    private let cache = Cache<String, User>()
    
    func loadUser(withEmail email: String, then handler: @escaping Handler)  {
        if let cached = cache[email] {
            return handler(.success(cached))
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncPrivateClient = appDelegate.appSyncPrivateClient
        let query = UsersByEmailQuery(email: email, limit: 1)
        
        appSyncPrivateClient?.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result, error in
            if let userItem = result?.data?.usersByEmail?.items.compactMap({ $0 }).first {
                let user = userItem.mapToUser()
                self.cache[email] = user
                handler(.success(user))
            } else {
                if let error = error {
                    handler(.failure(error))
                } else {
                    handler(.failure(UserLoaderError.UnknownError))
                }
            }
        }
    }
}
