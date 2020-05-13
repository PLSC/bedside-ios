//
//  Raters.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/24/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit




extension ListUsersQuery.Data.ListUser.Item : UserRepresentible {}

class RatersViewModel : ObservableObject {
    @Published var raters : [User] = []
    @Published var filterText : String = ""
    var filterIds : [String] = []
    
    var filteredUsers : [User] {
        return raters.filter(userSearchFilter(_:)).sorted { (user1, user2) -> Bool in
            return user1.sortName < user2.sortName
        }
    }
    
    init(filterIds: [String]) {
        self.filterIds = filterIds
    }
    
    func substring(_ substring: String, inString: String?) -> Bool {
       guard let string = inString else { return false }
       return string.lowercased().contains(substring.lowercased())
    }
    
    
    private func userSearchFilter(_ user: User) -> Bool {
        
        if filterIds.contains(user.id) {
            return false
        }
        
        //Show all users if there is no search text.
        if filterText.isEmpty {
            return true
        }
        
        //Show users with substrings of names.
        let substringInFirst = substring(filterText, inString: user.firstName)
        let substringInLast = substring(filterText, inString: user.lastName)
                
        return substringInFirst || substringInLast
    }
    
    func fetchRaters(orgId: String)  {
        let modelIDInput = ModelIDInput(eq: orgId)
        let userFilter = ModelUserFilterInput(orgId: modelIDInput)
        //TODO: Next token!
        let listUsersQuery = ListUsersQuery(filter: userFilter, limit: 1000)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        appSyncClient?.fetch(query: listUsersQuery, cachePolicy: .returnCacheDataAndFetch, resultHandler: { (result, error) in
            if let userItems = result?.data?.listUsers?.items {
                let users = userItems.compactMap { $0?.mapToUser() }
                self.raters = users
            }
        })
    }
}
