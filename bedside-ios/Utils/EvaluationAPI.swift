//
//  EvaluationAPI.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/23/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit

class EvaluationAPI {
    
    func dateString(date: Date) -> String {
        return ""
    }
    
    func createEvaluation(subject: User,
                          rater: User,
                          procedure: Procedure,
                          evaluationDate: Date,
                          errorHandler: @escaping (Error) -> ()) {
        let evalDateString = dateString(date: evaluationDate)
        let input = CreateEvaluationInput(subjectId: subject.id, raterId: rater.id, procedureId: procedure.id, evauluationDate: evalDateString)
        createEvaluation(createEvaluationInput: input, callback: errorHandler)
    }
    
    private func createEvaluation(createEvaluationInput: CreateEvaluationInput, callback: @escaping (Error) -> ()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        let mutation  = CreateEvaluationMutation(input: createEvaluationInput)
        appSyncClient?.perform(mutation: mutation, resultHandler: { (result, error) in
            if let e = error {
                print("Error creating evaluation: \(e)")
                callback(e)
            }
        })
    }
}
