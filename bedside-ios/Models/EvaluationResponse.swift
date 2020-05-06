//
//  EvaluationResponse.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/5/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation

public struct EvaluationResponse: Identifiable, Codable {
    public let id : String
    public let subject : User
    public let rater : User
    public let procedure : Procedure
    public let evaluationDate : Date
    public let ratingLevel : Int
}


