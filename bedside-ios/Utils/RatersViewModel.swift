//
//  Raters.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/24/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}


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
    
    func fetchRaters(organization: Organization) {
        
        let orgId = ModelIDInput(eq: organization.id)
        let filter = ModelProgramFilterInput(orgId: orgId)
        //TODO: allow next tokens and pagination if necessary.
        let query = ListProgramsQuery(filter: filter, limit: 1000)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        appSyncClient?.fetch(query: query, cachePolicy: .returnCacheDataAndFetch, resultHandler: { (result, error) in
            if let programItems = result?.data?.listPrograms?.items {
                let userItems = programItems.compactMap { programItem in
                    programItem?.memberships
                }.flatMap {
                    $0.items!
                }.map {
                    $0?.user
                }
                
                let users = userItems.compactMap { userItem -> User? in
                    guard let u = userItem else { return nil }
                    return User(id: u.id, userName: u.userName, email: u.email, phone: u.phone, firstName: u.firstName, lastName: u.lastName, npi: u.npi)
                }
                
                self.raters = users.uniques
                
                
            }
        })
    }
}
