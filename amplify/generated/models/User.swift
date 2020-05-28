// swiftlint:disable all
import Amplify
import Foundation

protocol UserRepresentible {
    var id: String { get }
    var userName: String? { get }
    var email: String { get }
    var phone: String? { get }
    var firstName: String? { get }
    var lastName: String? { get }
    var npi: Int? { get }
    var orgId: String? {get}
}

extension ListCertificationRecordsQuery.Data.ListCertificationRecord.Item.CertificationLog.Item.Subject: UserRepresentible {}
extension ListCertificationRecordsQuery.Data.ListCertificationRecord.Item.CertificationLog.Item.Rater: UserRepresentible {}
extension UsersByEmailQuery.Data.UsersByEmail.Item: UserRepresentible {}
extension UpdateUserMutation.Data.UpdateUser: UserRepresentible {}

public struct User: Identifiable, UserRepresentible {    
  public let id: String
  public let orgId: String?
  public var userName: String?
  public var email: String
  public var phone: String?
  public var firstName: String?
  public var lastName: String?
  public var npi: Int?
  public var memberships: [Membership]?
  
  public init(id: String = UUID().uuidString,
      userName: String? = nil,
      email: String,
      phone: String? = nil,
      firstName: String? = nil,
      lastName: String? = nil,
      npi: Int? = nil,
      memberships: [Membership]? = [],
      orgId: String? = nil) {
      self.id = id
      self.userName = userName
      self.email = email
      self.phone = phone
      self.firstName = firstName
      self.lastName = lastName
      self.npi = npi
      self.memberships = memberships
      self.orgId = orgId
  }
}

extension User {
    
    var sortName : String {
        get {
            switch (self.firstName, self.lastName, self.email) {
            case let (nil, nil, email):
                return email
            case let (firstName, lastName?, _):
                return "\(lastName) \(firstName ?? "")"
            default:
                return ""
            }
        }
    }
    
    var displayName : String {
        get {
            switch (self.firstName, self.lastName, self.email) {
            case let (firstName?, lastName?, _):
                return "Dr. \(firstName) \(lastName)"
            case let (nil, lastName?, _):
                return "Dr. \(lastName)"
            case let (nil, nil, email):
                return email
            default:
                return ""
            }
        }
    }
}

extension User : Hashable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
