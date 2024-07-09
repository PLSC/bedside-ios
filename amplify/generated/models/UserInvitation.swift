// swiftlint:disable all
import Amplify
import Foundation

public struct UserInvitation: Model {
  public let id: String
  public var orgID: String
  public var invitee: User
  public var invitationStatus: InvitationStatus
  public var email: String
  public var programAdminId: String?
  public var permission: Permission?
  
  public init(id: String = UUID().uuidString,
      orgID: String,
      invitee: User,
      invitationStatus: InvitationStatus,
      email: String,
      programAdminId: String? = nil,
      permission: Permission? = nil) {
      self.id = id
      self.orgID = orgID
      self.invitee = invitee
      self.invitationStatus = invitationStatus
      self.email = email
      self.programAdminId = programAdminId
      self.permission = permission
  }
}