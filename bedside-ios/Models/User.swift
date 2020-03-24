// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var userName: String?
  public var email: String
  public var phone: String?
  public var firstName: String?
  public var lastName: String?
  public var npi: Int?
  public var memberships: List<Membership>?
  
  public init(id: String = UUID().uuidString,
      userName: String? = nil,
      email: String,
      phone: String? = nil,
      firstName: String? = nil,
      lastName: String? = nil,
      npi: Int? = nil,
      memberships: List<Membership>? = []) {
      self.id = id
      self.userName = userName
      self.email = email
      self.phone = phone
      self.firstName = firstName
      self.lastName = lastName
      self.npi = npi
      self.memberships = memberships
  }
}