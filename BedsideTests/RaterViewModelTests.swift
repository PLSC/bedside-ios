//
//  RaterViewModelTests.swift
//  BedsideTests
//
//  Created by Andrew Lenox on 6/24/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import XCTest
@testable import Bedside

class RaterViewModelTests: XCTestCase {
    
    var raters : [User] = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let user1 = User(id: "1", userName: "andy", email: "andy@test.com", phone: nil, firstName: "Andy", lastName: "Lenox", npi: nil, memberships: nil, orgId: "1")
        let user2 = User(id: "2", userName: "sean", email: "sean@test.com", phone: nil, firstName: "Sean", lastName: "Loiselle", npi: nil, memberships: nil, orgId: "1")
        let user3 = User(id: "3", userName: "mary", email: "mary@test.com", phone: nil, firstName: "Mary", lastName: "Schuller", npi: nil, memberships: nil, orgId: "1")
        
        raters.append(user1)
        raters.append(user2)
        raters.append(user3)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let viewModel = RatersViewModel(filterIds: ["1"])
        XCTAssert(viewModel.filterIds.count == 1, "Filter ID's should be 1")
    }
    
    
}
