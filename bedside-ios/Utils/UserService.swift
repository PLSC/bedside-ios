//
//  UserService.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 6/24/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit

protocol UserService {
    func fetchUsers(orgId: String, withFilterText filter: String)
    func fetchAllUsers(orgId:String)
}

class AppSyncUserService: UserService {
    
    var raters : [User] = []
    
    func fetchUsers(orgId: String, withFilterText filter: String) {
        
    }
    
    func fetchAllUsers(orgId: String) {
        
    }
    
    //TODO: Error handling!
    func fetchUsers(filter: ModelUserFilterInput, nextToken: String? = nil) {
        let listUsersQuery = ListUsersQuery(filter: filter, limit: 1000, nextToken: nextToken)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        appSyncClient?.fetch(query: listUsersQuery, cachePolicy: .returnCacheDataAndFetch, resultHandler: {
            [weak self] (result, error) in
            guard let strongSelf = self else { return }
            if let userItems = result?.data?.listUsers?.items {
                let users = userItems.compactMap { $0?.mapToUser() }
                if nextToken != nil {
                    let uniqueUsers = (strongSelf.raters + users).uniques
                    strongSelf.raters = uniqueUsers
                } else {
                    strongSelf.raters = users
                }
            }
            
            if let next = result?.data?.listUsers?.nextToken {
                strongSelf.fetchUsers(filter: filter, nextToken: next)
            }
       })
    }
}
