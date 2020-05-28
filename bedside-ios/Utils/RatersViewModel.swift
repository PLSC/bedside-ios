//
//  Raters.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/24/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit
import Combine

class RatersViewModel : ObservableObject {
    @Published var raters : [User] = []
    @Published var filterText : String = ""
    @Published var filteredUsers : [User] = []
    var filterIds : [String] = []
    var cancellableSet : Set<AnyCancellable> = []
    
    init(filterIds: [String]) {
        self.filterIds = filterIds
        
        $raters.receive(on: RunLoop.main).map { users in
            users.filter(self.userSearchFilter(_:)).sorted { (user1, user2) -> Bool in
                return user1.sortName < user2.sortName
            }
        }
        .assign(to: \.filteredUsers, on: self)
        .store(in: &cancellableSet)
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
        let substringInEmail = substring(filterText, inString: user.email)
                
        return substringInFirst || substringInLast || substringInEmail
    }
    
    func fetchRaters(orgId: String)  {
        let modelIDInput = ModelIDInput(eq: orgId)
        let userFilter = ModelUserFilterInput(orgId: modelIDInput)
        //TODO: Next token!
        let listUsersQuery = ListUsersQuery(filter: userFilter, limit: 2000)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        appSyncClient?.fetch(query: listUsersQuery, cachePolicy: .returnCacheDataAndFetch, resultHandler: {
            [weak self] (result, error) in
            guard let strongSelf = self else { return }
            if let userItems = result?.data?.listUsers?.items {
                let users = userItems.compactMap { $0?.mapToUser() }
                strongSelf.raters = users
            }
        })
    }
}
