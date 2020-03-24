// swiftlint:disable all
import Amplify
import Foundation

extension User {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case userName
    case email
    case phone
    case firstName
    case lastName
    case npi
    case memberships
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let user = User.keys
    
    model.pluralName = "Users"
    
    model.fields(
      .id(),
      .field(user.userName, is: .optional, ofType: .string),
      .field(user.email, is: .required, ofType: .string),
      .field(user.phone, is: .optional, ofType: .string),
      .field(user.firstName, is: .optional, ofType: .string),
      .field(user.lastName, is: .optional, ofType: .string),
      .field(user.npi, is: .optional, ofType: .int),
      .hasMany(user.memberships, is: .optional, ofType: Membership.self, associatedWith: Membership.keys.user)
    )
    }
}