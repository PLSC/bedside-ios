// swiftlint:disable all
import Amplify
import Foundation

extension EvaluationResponse {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case rater
    case evaluationDate
    case ratingLevel
    case certificationRecordId
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let evaluationResponse = EvaluationResponse.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "EvaluationResponses"
    
    model.fields(
      .id(),
      .belongsTo(evaluationResponse.rater, is: .required, ofType: User.self, targetName: "raterId"),
      .field(evaluationResponse.evaluationDate, is: .required, ofType: .dateTime),
      .field(evaluationResponse.ratingLevel, is: .optional, ofType: .int),
      .field(evaluationResponse.certificationRecordId, is: .optional, ofType: .string)
    )
    }
}
