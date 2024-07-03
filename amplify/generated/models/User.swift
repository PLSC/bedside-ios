// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var orgID: String?
  public var userName: String?
  public var email: String?
  public var phone: String?
  public var firstName: String?
  public var lastName: String?
  public var npi: Int?
  public var pgy: Int?
  public var isRater: Bool?
  public var memberships: List<Membership>?
  public var settings: UserSettings?
  public var lastLogin: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      orgID: String? = nil,
      userName: String? = nil,
      email: String? = nil,
      phone: String? = nil,
      firstName: String? = nil,
      lastName: String? = nil,
      npi: Int? = nil,
      pgy: Int? = nil,
      isRater: Bool? = nil,
      memberships: List<Membership>? = [],
      settings: UserSettings? = nil,
      lastLogin: Temporal.DateTime? = nil) {
      self.id = id
      self.orgID = orgID
      self.userName = userName
      self.email = email
      self.phone = phone
      self.firstName = firstName
      self.lastName = lastName
      self.npi = npi
      self.pgy = pgy
      self.isRater = isRater
      self.memberships = memberships
      self.settings = settings
      self.lastLogin = lastLogin
  }
}