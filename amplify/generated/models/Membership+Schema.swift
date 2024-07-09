// swiftlint:disable all
import Amplify
import Foundation

extension Membership {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case role
    case user
    case program
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let membership = Membership.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read]),
      rule(allow: .public, operations: [.read])
    ]
    
    model.pluralName = "Memberships"
    
    model.fields(
      .id(),
      .field(membership.role, is: .required, ofType: .enum(type: Role.self)),
      .belongsTo(membership.user, is: .required, ofType: User.self, targetName: "userId"),
      .belongsTo(membership.program, is: .required, ofType: Program.self, targetName: "programId")
    )
    }
}