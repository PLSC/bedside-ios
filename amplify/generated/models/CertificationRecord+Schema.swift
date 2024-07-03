// swiftlint:disable all
import Amplify
import Foundation

extension CertificationRecord {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case procedure
    case isCertified
    case certificationMethod
    case subject
    case certificationLog
    case totalProcedureEvals
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let certificationRecord = CertificationRecord.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read]),
      rule(allow: .public, operations: [.read])
    ]
    
    model.pluralName = "CertificationRecords"
    
    model.fields(
      .id(),
      .belongsTo(certificationRecord.procedure, is: .optional, ofType: Procedure.self, targetName: "procedureId"),
      .field(certificationRecord.isCertified, is: .optional, ofType: .bool),
      .field(certificationRecord.certificationMethod, is: .optional, ofType: .enum(type: CertificationMethod.self)),
      .belongsTo(certificationRecord.subject, is: .required, ofType: User.self, targetName: "subjectId"),
      .hasMany(certificationRecord.certificationLog, is: .optional, ofType: EvaluationResponse.self, associatedWith: EvaluationResponse.keys.certificationRecordId),
      .field(certificationRecord.totalProcedureEvals, is: .optional, ofType: .int)
    )
    }
}