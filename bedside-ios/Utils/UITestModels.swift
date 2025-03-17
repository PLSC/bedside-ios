//
//  UITestModels.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/7/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import Amplify

struct UITestModels {
    static let proceduresTestData = [
        Procedure(id: "1", name: "Central Line", description: "A line that goes into your center"),
        Procedure(id: "2", name: "Arterial Line", description: "A line that goes into your artery")
    ]

    static let certRecordTestData = [
        CertificationRecord(id: "1", procedure: proceduresTestData[0], isCertified: true, certificationMethod: nil, subject: User(id: "1"), certificationLog: nil, totalProcedureEvals: 2),
        CertificationRecord(id: "2", procedure: proceduresTestData[0], isCertified: false, certificationMethod: nil, subject: User(id: "1"), certificationLog: nil, totalProcedureEvals: 3)
    ]

    static let usersTestData = [
        User(id: "1", userName: "andylenox", email: "alenox@umich.edu", phone: "8108767864", firstName: "Andrew", lastName: "Lenox", npi: 104952235, memberships: nil),
        User(id: "2", userName: "brianGeorge", email: "bg@briangeorge.net", phone: "8101021039", firstName: "Brian", lastName: "George", npi: 10349080, memberships: nil)
    ]

    static let evalResponseTestData = [EvaluationResponse(id: "1", rater: UITestModels.usersTestData[1], evaluationDate: Temporal.DateTime(Date()), ratingLevel: 4)]
}
