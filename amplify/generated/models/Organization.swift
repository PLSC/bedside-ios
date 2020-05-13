// swiftlint:disable all
import Amplify
import Foundation

public struct Organization {
  public let id: String
  public var title: String?
  public var description: String?
  public var programs: [Program]?
  
  public init(id: String = UUID().uuidString,
      title: String? = nil,
      description: String? = nil,
      programs: [Program]? = []) {
      self.id = id
      self.title = title
      self.description = description
      self.programs = programs
  }
}
