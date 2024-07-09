// swiftlint:disable all
import Amplify
import Foundation

extension Procedure {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case description
    case programs
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let procedure = Procedure.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read]),
      rule(allow: .public, operations: [.read])
    ]
    
    model.pluralName = "Procedures"
    
    model.fields(
      .id(),
      .field(procedure.name, is: .required, ofType: .string),
      .field(procedure.description, is: .optional, ofType: .string),
      .hasMany(procedure.programs, is: .optional, ofType: ProgramProcedure.self, associatedWith: ProgramProcedure.keys.procedure)
    )
    }
}