// swiftlint:disable all
import Amplify
import Foundation

public struct Membership: Identifiable {
  public let id: String
  public var role: RoleModel
  public var user: User
  public var program: Program
  
  public init(id: String = UUID().uuidString,
      role: RoleModel,
      user: User,
      program: Program) {
      self.id = id
      self.role = role
      self.user = user
      self.program = program
  }
}

extension Membership: Hashable {
    public static func == (lhs: Membership, rhs: Membership) -> Bool {
        return lhs.id == rhs.id
    }
}
