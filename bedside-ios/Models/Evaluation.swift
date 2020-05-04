//
//  Evaluation.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/27/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation

class Evaluation : ObservableObject {
    @Published var procedure: Procedure?
    @Published var rater: User?
    @Published var subject: User?
    @Published var procedureDate: Date
    @Published var answer: AnswerOption<Int>?
    
    init(rater: User?  = nil,
         subject: User? = nil,
         procedure: Procedure? = nil,
         procedureDate: Date = Date(),
         answer: AnswerOption<Int>? = nil) {
        self.rater = rater
        self.subject = subject
        self.procedure = procedure
        self.procedureDate = procedureDate
        self.answer = answer
    }
    
    func procedureIsValid() -> Bool {
        return procedure != nil
    }
       
    func dateIsValid() -> Bool {
        return procedureDate < Date()
    }
       
    func raterIsValid() -> Bool {
        return rater != nil
    }
    
    func subjectIsValid() -> Bool {
        return subject != nil
    }
    
    func answerIsValid() -> Bool {
        return answer != nil
    }
    
    func reset() {
        rater = nil
        subject = nil
        procedureDate = Date()
        answer = nil
        procedure = nil
    }
    
    func isValid() -> Bool {
        return raterIsValid() &&
            subjectIsValid() &&
            dateIsValid() &&
            procedureIsValid() &&
            answerIsValid()
    }
}
