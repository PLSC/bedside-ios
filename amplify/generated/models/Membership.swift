// swiftlint:disable all
import Amplify
import Foundation

public struct Membership: Model, Codable {
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
