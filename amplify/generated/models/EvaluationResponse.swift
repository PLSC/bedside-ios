// swiftlint:disable all
import Amplify
import Foundation

public struct EvaluationResponse: Model {
  public let id: String
  public var rater: User
  public var evaluationDate: Temporal.DateTime
  public var ratingLevel: Int?
  public var certificationRecordId: String?
  
  public init(id: String = UUID().uuidString,
      rater: User,
      evaluationDate: Temporal.DateTime,
      ratingLevel: Int? = nil,
      certificationRecordId: String? = nil) {
      self.id = id
      self.rater = rater
      self.evaluationDate = evaluationDate
      self.ratingLevel = ratingLevel
      self.certificationRecordId = certificationRecordId
  }
}
