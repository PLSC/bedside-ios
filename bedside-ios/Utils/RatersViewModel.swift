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
    let userService : UserService
    
    init(filterIds: [String], userService: UserService = AppSyncUserService()) {
        self.filterIds = filterIds
        self.userService = userService
        
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
    
    //TODO: Error handling
    func fetchRatersWithFilter(orgId: String, filterText: String) {
        self.orgId = orgId
        self.userService.fetchUsers(orgId: orgId, withFilterText: filterText) { (result) in
            switch result {
            case .success(let users):
                self.raters = users
            case .failure(let error):
                print("Error fetching users: \(error)")
            }
        }
    }
    

    //TODO: Error handling
    func fetchRaters(orgId: String)  {
        self.orgId = orgId
        self.userService.fetchUsers(orgId: orgId, withFilterText: nil) { (result) in
            switch result {
            case .success(let users):
                self.raters = users
            case .failure(let error):
                print("Error fetching users \(error)")
            }
        }
    }
}
