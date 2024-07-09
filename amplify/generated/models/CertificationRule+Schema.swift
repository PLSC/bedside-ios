// swiftlint:disable all
import Amplify
import Foundation

extension CertificationRule {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case organization
    case program
    case numOfEvals
    case atLevel
    case procedure
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let certificationRule = CertificationRule.keys
    
    model.pluralName = "CertificationRules"
    
    model.fields(
      .id(),
      .field(certificationRule.organization, is: .optional, ofType: .model(type: Organization.self)),
      .field(certificationRule.program, is: .optional, ofType: .model(type: Program.self)),
      .field(certificationRule.numOfEvals, is: .optional, ofType: .int),
      .field(certificationRule.atLevel, is: .optional, ofType: .int),
      .field(certificationRule.procedure, is: .optional, ofType: .model(type: Procedure.self))
    )
    }
}
