// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var userName: String
  public var email: String?
  public var phone: String?
  
  public init(id: String = UUID().uuidString,
      userName: String,
      email: String? = nil,
      phone: String? = nil) {
      self.id = id
      self.userName = userName
      self.email = email
      self.phone = phone
  }
}