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
    
    @Published var orgId : String = ""
    @Published var raters : [User] = []
    @Published var filterText : String = ""
    @Published var filteredUsers : [User] = []
    @Published var showError : Bool = false
    @Published var errorMessage : String = ""
    
    var cancellableSet : Set<AnyCancellable> = []
    let userService : UserService
    
    init(userService: UserService = AppSyncUserService()) {
        self.userService = userService
        Publishers.CombineLatest($raters, $filterText)
            .receive(on: RunLoop.main)
            .map {
                raters, filterText in
                let sortedRaters = raters.sorted {  $0.sortName < $1.sortName }
                if filterText.isEmpty {
                    return sortedRaters
                } else {
                    return sortedRaters.filter { rater in
                        rater.displayName.lowercased().contains(filterText.lowercased())
                    }
                }
            }
            .assign(to: \.filteredUsers, on: self)
            .store(in: &cancellableSet)
    }

    func fetchRaters(orgId: String)  {
        self.orgId = orgId
        self.userService.fetchUsers(orgId: orgId, withFilterText: nil) { (result) in
            switch result {
            case .success(let users):
                print("Raters gathered")
                self.raters = users
            case .failure(let error):
                self.showError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
