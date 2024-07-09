// swiftlint:disable all
import Amplify
import Foundation

extension Organization {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case description
    case ipRangeRegex
    case programs
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let organization = Organization.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read]),
      rule(allow: .public, operations: [.read])
    ]
    
    model.pluralName = "Organizations"
    
    model.fields(
      .id(),
      .field(organization.title, is: .optional, ofType: .string),
      .field(organization.description, is: .optional, ofType: .string),
      .field(organization.ipRangeRegex, is: .optional, ofType: .string),
      .hasMany(organization.programs, is: .optional, ofType: Program.self, associatedWith: Program.keys.orgID)
    )
    }
}