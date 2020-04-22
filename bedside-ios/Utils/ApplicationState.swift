//
//  ApplicationState.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/21/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit
import AWSMobileClient

class ApplicationState: ObservableObject {
    @Published var organization : Organization?
    @Published var currentUser : User?
    
    func fetchUserInfo() {
        //get logged in user email
        AWSMobileClient.default().getUserAttributes { (attributes, error) in
            if let email = attributes?["email"] {
                self.fetchUserInfo(email: email)
            }
        }
    }
    
    func fetchUserInfo(email: String) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let appSyncClient = appDelegate.appSyncClient
            appSyncClient?.fetch(query:  UsersByEmailQuery(email: email, limit: 1), cachePolicy: .returnCacheDataAndFetch) {
                (result, error ) in
                
                if let userItem = result?.data?.usersByEmail?.items?.compactMap({ $0 }).first {
                    self.currentUser = User(id: userItem.id, userName: userItem.userName, email: userItem.email, phone: userItem.phone, firstName: userItem.firstName, lastName: userItem.lastName, npi: userItem.npi)
                    if let orgId = userItem.memberships?.items?[0]?.program.orgId {
                        appSyncClient?.fetch(query: GetOrganizationQuery(id: orgId), cachePolicy: .returnCacheDataAndFetch) {
                            (result, error) in
                            if let org = result?.data?.getOrganization {
                                self.organization = Organization(id: org.id, title: org.title, description: org.description)
                                let programs = org.programs?.items?.compactMap({ (item) -> Program? in
                                    return Program(id: item?.id ?? "", name: item?.name ?? "", orgID: item?.orgId ?? "", description: item?.description, memberships: nil)
                                })
                                print(programs ?? "nil")
                            }
                        }
                    }
                }
            }
        }
    }
    
    init() {
        fetchUserInfo()
    }
}
