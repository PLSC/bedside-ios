// swiftlint:disable all
import Amplify
import Foundation

extension UserInvitation {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case orgID
    case invitee
    case invitationStatus
    case email
    case programAdminId
    case permission
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userInvitation = UserInvitation.keys
    
    model.authRules = [
      rule(allow: .private, operations: [.create, .update, .delete, .read]),
      rule(allow: .public, operations: [.read])
    ]
    
    model.pluralName = "UserInvitations"
    
    model.fields(
      .id(),
      .field(userInvitation.orgID, is: .required, ofType: .string),
      .belongsTo(userInvitation.invitee, is: .required, ofType: User.self, targetName: "inviteeId"),
      .field(userInvitation.invitationStatus, is: .required, ofType: .enum(type: InvitationStatus.self)),
      .field(userInvitation.email, is: .required, ofType: .string),
      .field(userInvitation.programAdminId, is: .optional, ofType: .string),
      .field(userInvitation.permission, is: .optional, ofType: .enum(type: Permission.self))
    )
    }
}