// swiftlint:disable all
import Amplify
import Foundation

extension ProgramProcedure {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case procedure
    case program
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let programProcedure = ProgramProcedure.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read]),
      rule(allow: .public, operations: [.read])
    ]
    
    model.pluralName = "ProgramProcedures"
    
    model.fields(
      .id(),
      .belongsTo(programProcedure.procedure, is: .required, ofType: Procedure.self, targetName: "procedureId"),
      .belongsTo(programProcedure.program, is: .required, ofType: Program.self, targetName: "programId")
    )
    }
}