//
//  RaterViewModelTests.swift
//  BedsideTests
//
//  Created by Andrew Lenox on 6/24/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import XCTest
import Combine
@testable import Bedside

class MockUserService: UserService {
    
    var raters : [User] = []
    
    init() {
        let user1 = User(id: "1", userName: "andy", email: "andy@test.com", phone: nil, firstName: "Andy", lastName: "Lenox", npi: nil, memberships: nil, orgId: "1")
        let user2 = User(id: "2", userName: "sean", email: "sean@test.com", phone: nil, firstName: "Sean", lastName: "Loiselle", npi: nil, memberships: nil, orgId: "1")
        let user3 = User(id: "3", userName: "mary", email: "mary@test.com", phone: nil, firstName: "Mary", lastName: "Schuller", npi: nil, memberships: nil, orgId: "1")
               
       raters.append(user1)
       raters.append(user2)
       raters.append(user3)
    }
    
    func fetchUsers(orgId: String, withFilterText filter: String?, completion: @escaping Handler) {
        if let filter = filter {
            let filteredUsers = raters.filter {
                return ($0.firstName?.contains(filter) ?? false)
            }
            completion(.success(filteredUsers))
        } else {
            completion(.success(raters))
        }
    }
}

class RaterViewModelTests: XCTestCase {
    
    var cancelableSet : Set<AnyCancellable> = []
    
    func testFetchUsers() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let viewModel = RatersViewModel(filterIds: ["1"], userService: MockUserService())
        viewModel.fetchRaters(orgId: "1")
        XCTAssert(viewModel.raters.count == 3, "Fetch results contain 3 total users")
    }
    
    
    func testFilterUserId() throws {
        let viewModel = RatersViewModel(filterIds: ["1"], userService: MockUserService())
        viewModel.fetchRaters(orgId: "1")
        let expectation = XCTestExpectation(description: "filtered users should be updated")
        
        viewModel.$filteredUsers.receive(on: RunLoop.main)
            .filter({ users -> Bool in
                users.count > 0
            })
            .sink { (users) in
                XCTAssert(users.count == 2, "filteredUsers should be 2 when initialized.")
                expectation.fulfill()
            }
            .store(in: &cancelableSet)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFilterUser() throws {
        let viewModel = RatersViewModel(filterIds: ["1"], userService: MockUserService())
        viewModel.fetchRatersWithFilter(orgId: "1", filterText: "Sean")
        let expectation = XCTestExpectation(description: "filtered users should be updated")
        
        viewModel.$filteredUsers.receive(on: RunLoop.main)
            .filter { $0.count > 0 }
            .sink { users in
                XCTAssert(users.count == 1, "Filtered Users should be 1 when filtering by Name")
                expectation.fulfill()
            }
            .store(in: &cancelableSet)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
}
