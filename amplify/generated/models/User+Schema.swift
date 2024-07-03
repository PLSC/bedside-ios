// swiftlint:disable all
import Amplify
import Foundation

extension User {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case orgID
    case userName
    case email
    case phone
    case firstName
    case lastName
    case npi
    case pgy
    case isRater
    case memberships
    case settings
    case lastLogin
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let user = User.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read]),
      rule(allow: .public, operations: [.read, .update])
    ]
    
    model.pluralName = "Users"
    
    model.fields(
      .id(),
      .field(user.orgID, is: .optional, ofType: .string),
      .field(user.userName, is: .optional, ofType: .string),
      .field(user.email, is: .optional, ofType: .string),
      .field(user.phone, is: .optional, ofType: .string),
      .field(user.firstName, is: .optional, ofType: .string),
      .field(user.lastName, is: .optional, ofType: .string),
      .field(user.npi, is: .optional, ofType: .int),
      .field(user.pgy, is: .optional, ofType: .int),
      .field(user.isRater, is: .optional, ofType: .bool),
      .hasMany(user.memberships, is: .optional, ofType: Membership.self, associatedWith: Membership.keys.user),
      .field(user.settings, is: .optional, ofType: .embedded(type: UserSettings.self)),
      .field(user.lastLogin, is: .optional, ofType: .dateTime)
    )
    }
}