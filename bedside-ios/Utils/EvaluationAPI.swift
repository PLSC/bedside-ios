//
//  EvaluationAPI.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/23/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit

enum EvaluationAPIError : Error {
    case InvalidEvaluationData
}

class EvaluationAPI {
    
    func createEvaluation(subject: User,
                          rater: User,
                          procedure: Procedure,
                          procedureDate: Date,
                          ratingLevel: Int,
                          errorHandler: @escaping (Error?) -> ()) {
        let evalDateString = procedureDate.awsDateTimeString
        let input = CreateEvaluationResponseInput(subjectId: subject.id, raterId: rater.id, procedureId: procedure.id, evaluationDate: evalDateString, ratingLevel: ratingLevel)
        createEvaluation(createEvaluationInput: input, callback: errorHandler)
    }
    
    private func createEvaluation(createEvaluationInput: CreateEvaluationResponseInput, callback: @escaping (Error?) -> ()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncPrivateClient = appDelegate.appSyncPrivateClient
        let mutation  = NewEvaluationResponseQuery(evaluationResponse: createEvaluationInput)
        
        appSyncPrivateClient?.fetch(query: mutation, resultHandler: {(result, error) in
            if let e = error {
                print("Error creating evaluation: \(e)")
            }
            callback(error)
        })
    }
}
