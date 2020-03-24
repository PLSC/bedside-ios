// swiftlint:disable all
import Amplify
import Foundation

public struct Program: Model {
  public let id: String
  public var name: String
  public var orgID: String
  public var description: String?
  public var memberships: List<Membership>?
  
  public init(id: String = UUID().uuidString,
      name: String,
      orgID: String,
      description: String? = nil,
      memberships: List<Membership>? = []) {
      self.id = id
      self.name = name
      self.orgID = orgID
      self.description = description
      self.memberships = memberships
  }
}