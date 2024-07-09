// swiftlint:disable all
import Amplify
import Foundation

public struct Organization: Model {
  public let id: String
  public var title: String?
  public var description: String?
  public var ipRangeRegex: String?
  public var programs: List<Program>?
  
  public init(id: String = UUID().uuidString,
      title: String? = nil,
      description: String? = nil,
      ipRangeRegex: String? = nil,
      programs: List<Program>? = []) {
      self.id = id
      self.title = title
      self.description = description
      self.ipRangeRegex = ipRangeRegex
      self.programs = programs
  }
}