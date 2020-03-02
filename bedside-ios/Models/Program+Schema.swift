// swiftlint:disable all
import Amplify
import Foundation

extension Program {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case description
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let program = Program.keys
    
    model.pluralName = "Programs"
    
    model.fields(
      .id(),
      .field(program.name, is: .required, ofType: .string),
      .field(program.description, is: .optional, ofType: .string)
    )
    }
}