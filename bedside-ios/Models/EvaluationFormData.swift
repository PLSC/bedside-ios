//
//  Evaluation.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/27/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import Combine

class EvaluationFormData : ObservableObject {
    @Published var procedure: Procedure?
    @Published var rater: User?
    @Published var subject: User?
    @Published var procedureDate: Date
    @Published var answer: AnswerOption<Int>?
    
    var cancelable : AnyCancellable? = nil
    
    var usersAreValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($rater, $subject)
            .receive(on: RunLoop.main)
            .map {
                rater, subject in
                guard let _ = rater, let _ = subject else { return false }
                return true
            }.eraseToAnyPublisher()
    }
    
    var procedureIsValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($procedure, $procedureDate)
            .receive(on: RunLoop.main)
            .map {
                procedure, procedureDate in
                guard let _ = procedure else { return false }
                //TODO: validate date
                return true
            }.eraseToAnyPublisher()
    }
    
    var evaluationIsValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(usersAreValid, procedureIsValid, $answer)
            .receive(on: RunLoop.main)
            .map {
                usersValid, proceduresValid, answer in
                return usersValid && proceduresValid && answer != nil
                
        }.eraseToAnyPublisher()
    }
    
    func oldestValidEvalDate() -> Date {
           var dateComponents = DateComponents()
           dateComponents.hour = -72
           return Calendar.current.date(byAdding: dateComponents, to: Date())!
    }
    
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
    
    func submitEvaluation(completion: @escaping (Error?)->()) {
        let api = EvaluationAPI()
        api.createEvaluation(subject: subject!,
                             rater: rater!,
                             procedure: procedure!,
                             procedureDate: procedureDate,
                             ratingLevel: answer!.assocValue,
                             errorHandler: completion)
    }
    
    func reset() {
        rater = nil
        procedureDate = Date()
        answer = nil
        procedure = nil
    }
}
