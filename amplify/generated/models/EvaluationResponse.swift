// swiftlint:disable all
import Amplify
import Foundation

public struct EvaluationResponse: Model {
  public let id: String
  public var subject: User
  public var rater: User
  public var procedure: Procedure?
  public var evaluationDate: Temporal.DateTime
  public var ratingLevel: Int?
  public var certificationRecordId: String?
  
  public init(id: String = UUID().uuidString,
      subject: User,
      rater: User,
      procedure: Procedure? = nil,
      evaluationDate: Temporal.DateTime,
      ratingLevel: Int? = nil,
      certificationRecordId: String? = nil) {
      self.id = id
      self.subject = subject
      self.rater = rater
      self.procedure = procedure
      self.evaluationDate = evaluationDate
      self.ratingLevel = ratingLevel
      self.certificationRecordId = certificationRecordId
  }
}