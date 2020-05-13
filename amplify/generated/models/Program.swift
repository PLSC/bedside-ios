// swiftlint:disable all
import Amplify
import Foundation

public struct Program: Identifiable {
  public let id: String
  public var name: String
  public var orgID: String
  public var description: String?
  public var memberships: [Membership]?
  
  public init(id: String = UUID().uuidString,
      name: String,
      orgID: String,
      description: String? = nil,
      memberships: [Membership]? = []) {
      self.id = id
      self.name = name
      self.orgID = orgID
      self.description = description
      self.memberships = memberships
  }
}

extension Program: Hashable {
    public static func == (lhs: Program, rhs: Program) -> Bool {
        return lhs.id == rhs.id
    }
}
