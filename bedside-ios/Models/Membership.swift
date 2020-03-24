// swiftlint:disable all
import Amplify
import Foundation

public struct Membership: Model {
  public let id: String
  public var role: Role
  public var user: User
  public var program: Program
  
  public init(id: String = UUID().uuidString,
      role: Role,
      user: User,
      program: Program) {
      self.id = id
      self.role = role
      self.user = user
      self.program = program
  }
}