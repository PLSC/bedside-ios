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
    
    func fetchRaters(organization: Organization) {
        
        let orgId = ModelIDInput(eq: organization.id)
        let filter = ModelProgramFilterInput(orgId: orgId)
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

    init() {
        
    }
}
