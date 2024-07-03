// swiftlint:disable all
import Amplify
import Foundation

public struct CertificationRecord: Model {
  public let id: String
  public var procedure: Procedure?
  public var isCertified: Bool?
  public var certificationMethod: CertificationMethod?
  public var subject: User
  public var certificationLog: List<EvaluationResponse>?
  public var totalProcedureEvals: Int?
  
  public init(id: String = UUID().uuidString,
      procedure: Procedure? = nil,
      isCertified: Bool? = nil,
      certificationMethod: CertificationMethod? = nil,
      subject: User,
      certificationLog: List<EvaluationResponse>? = [],
      totalProcedureEvals: Int? = nil) {
      self.id = id
      self.procedure = procedure
      self.isCertified = isCertified
      self.certificationMethod = certificationMethod
      self.subject = subject
      self.certificationLog = certificationLog
      self.totalProcedureEvals = totalProcedureEvals
  }
}