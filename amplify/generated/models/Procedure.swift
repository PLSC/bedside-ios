// swiftlint:disable all
import Amplify
import Foundation

public struct Procedure: Model, Identifiable, Codable {
  public let id: String
  public var name: String
  public var description: String?
  
  public init(id: String = UUID().uuidString,
      name: String,
      description: String? = nil) {
      self.id = id
      self.name = name
      self.description = description
  }
}
