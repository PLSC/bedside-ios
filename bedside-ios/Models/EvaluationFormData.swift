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
    @Published var procedureDate: Date = Date()
    @Published var answer: AnswerOption<Int>?
    @Published var evalIsValid : Bool = false
    @Published var readyForEvaluation: Bool = false

    
    var cancelableSet : Set<AnyCancellable> = []
    
    var attestation : String {
        guard let rater = rater, let subject = subject, let procedure = procedure, let answer = answer?.displayText else {
            return "Evaluation is incomplete."
        }
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .short
        dateformatter.locale = Locale(identifier: "en_US")
        let dateString = dateformatter.string(from: procedureDate)
        
        return "I, \(rater.displayName) attest that \(subject.displayName) performed a \(procedure.name) under my direct supervision on \(dateString). The following ratings reflect this specific observation of this trainee: \(answer)"
    }
    
    init() {
        Publishers.CombineLatest3(usersAreValid, procedureIsValid, $answer)
                   .receive(on: RunLoop.main)
                   .map {
                       usersValid, procedureIsValid, answer in
                       return usersValid && procedureIsValid && answer != nil
                    }
                    .assign(to: \.evalIsValid, on: self)
                    .store(in: &cancelableSet)
        
        Publishers.CombineLatest(usersAreValid, procedureIsValid)
            .receive(on: RunLoop.main)
            .map { usersAreValid, procedureIsValid in
                return usersAreValid && procedureIsValid
            }.assign(to: \.readyForEvaluation, on: self)
            .store(in: &cancelableSet)
    }
    
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
                [weak self] procedure, procedureDate in
                guard let _ = procedure, let s = self else { return false }
                return procedureDate >= s.oldestValidEvalDate()
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
