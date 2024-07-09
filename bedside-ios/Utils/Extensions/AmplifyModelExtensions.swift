//
//  AmplifyModelExtensions.swift
//  bedside-ios
//
//  Created by Chinthaka on 6/25/24.
//  Copyright © 2024 Andrew Lenox. All rights reserved.
//

import Foundation

extension User {

    var sortName : String {
        get {
            switch (self.firstName, self.lastName, self.email) {
            case let (nil, nil, email):
                return email!
            case let (firstName, lastName?, _):
                return "\(lastName) \(firstName ?? "")"
            default:
                return ""
            }
        }
    }

    var displayName : String {
        get {
            switch (self.firstName, self.lastName, self.email) {
            case let (firstName?, lastName?, _):
                return "Dr. \(firstName) \(lastName)"
            case let (nil, lastName?, _):
                return "Dr. \(lastName)"
            case let (nil, nil, email):
                return email ?? ""
            default:
                return ""
            }
        }
    }
}

extension User {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

extension EvaluationResponse {
    var ratingDisplayText : String? {
        get {
            return answerOptions.filter { (answerOption) -> Bool in
                answerOption.assocValue == self.ratingLevel
            }
            .first?.displayText
        }
    }
}

extension Procedure {

    public func belongsToAnyPrograms(ids: [String]) -> Bool {
        guard let programs = self.programs else {
            return false
        }

        for idToCheck in ids {
            if programs.contains(where: { $0.id == idToCheck }) {
                return true
            }
        }

        return false
    }
}
