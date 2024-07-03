//
//  EvaluationAPI.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 4/23/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit
import Amplify

enum EvaluationAPIError : Error {
    case InvalidEvaluationData
}

class EvaluationAPI {


    func createEvaluation(subject: User,
                          rater: User,
                          procedure: Procedure,
                          procedureDate: Date,
                          ratingLevel: Int) async -> Error? {
        let evalDateString = procedureDate.awsDateTimeString

        return await createEvaluation(subjectId: subject.id, raterId: rater.id, procedureId: procedure.id, evaluationDate: evalDateString, ratingLevel: ratingLevel)
    }

    private func createEvaluation(subjectId: String, raterId: String, procedureId: String, evaluationDate: String, ratingLevel: Int?) async -> Error? {
        let mutation = buildNewEvaluationResponseMutation(subjectId: subjectId, raterId: raterId, procedureId: procedureId, evaluationDate: evaluationDate, ratingLevel: ratingLevel)

        do {
            let result = try await Amplify.API.query(request: mutation)

            switch result {
            case .success(let evaluationResponse):
                NSLog("Create new evaluationResponse with id: \(evaluationResponse) succeed.")
                return nil
            case .failure(let error):
                NSLog("Create new evaluationResponse failed. error: \(error.debugDescription)")
                return error
            }
        } catch let error as GraphQLResponseError<User> {
            NSLog("Create new evaluationResponse failed. GraphQLResponseError: \(error.debugDescription)")
            return error
        } catch let error as APIError {
            NSLog("Create new evaluationResponse failed. Amplify.APIError: \(error.debugDescription)")
            return error
        } catch {
            if Task.isCancelled {
                NSLog("Update user mutation failed with Swift.CancellationError: \(error.localizedDescription)")
            } else {
                NSLog("Update user mutation failed: \(error)")
            }

            return error
        }
    }
}

extension EvaluationAPI {

    private func buildNewEvaluationResponseMutation(subjectId: String, raterId: String, procedureId: String, evaluationDate: String, ratingLevel: Int?) -> GraphQLRequest<String> {

        var evaluationResponse: [String: Any] = [:]

        evaluationResponse["subjectId"] = subjectId
        evaluationResponse["raterId"] = raterId
        evaluationResponse["procedureId"] = procedureId
        evaluationResponse["evaluationDate"] = evaluationDate

        if let ratingLevel = ratingLevel {
            evaluationResponse["ratingLevel"] = ratingLevel
        }

        let argumentValues = "evaluationResponse: $evaluationResponse"

        let query = """
        query NewEvaluationResponse($evaluationResponse: CreateEvaluationResponseInput) {
          newEvaluationResponse(\(argumentValues))
        }
        """

        return GraphQLRequest(
            document: query,
            variables: ["evaluationResponse": evaluationResponse],
            responseType: String.self,
            decodePath: "newEvaluationResponse"
        )
    }
}
