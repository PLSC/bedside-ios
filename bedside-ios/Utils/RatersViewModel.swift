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

//TODO: Make rater api dependency injected.
class RatersViewModel : ObservableObject {
    @Published var orgId : String = ""
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
        
        $filterText.receive(on: RunLoop.main)
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink {
                [weak self] filterText in
                guard let s = self else {return}
                if !filterText.isEmpty {
                    s.fetchRatersWithFilter(orgId: s.orgId, filterText: filterText)
                } else {
                    s.fetchRaters(orgId: s.orgId)
                }
            }.store(in: &cancellableSet)
        
    }
    
    private func userSearchFilter(_ user: User) -> Bool {
        return !filterIds.contains(user.id)
    }
    
    func fetchRatersWithFilter(orgId: String, filterText: String) {
        self.orgId = orgId
        let modelIDInput = ModelIDInput(eq: orgId)
        let filterStringInput = ModelStringInput(contains: filterText)
        let firstNameFilter = ModelUserFilterInput(orgId: modelIDInput, firstName: filterStringInput)
        let lastNameFilter = ModelUserFilterInput(orgId: modelIDInput, lastName: filterStringInput)
        let emailFilter = ModelUserFilterInput(orgId: modelIDInput, email: filterStringInput)
        let orFilter = ModelUserFilterInput(or:[firstNameFilter, lastNameFilter, emailFilter])
        fetchRaters(filter: orFilter)
    }
    
    //TODO: Error handling!
    func fetchRaters(filter: ModelUserFilterInput, nextToken: String? = nil) {
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
                strongSelf.fetchRaters(filter: filter, nextToken: next)
            }
       })
    }
    
    func fetchRaters(orgId: String)  {
        self.orgId = orgId
        let modelIDInput = ModelIDInput(eq: orgId)
        let userFilter = ModelUserFilterInput(orgId: modelIDInput)
        fetchRaters(filter: userFilter)
    }
}
