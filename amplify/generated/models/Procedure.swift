// swiftlint:disable all
import Amplify
import Foundation

public struct Procedure: Model {
  public let id: String
  public var name: String
  public var description: String?
  public var programs: List<ProgramProcedure>?
  
  public init(id: String = UUID().uuidString,
      name: String,
      description: String? = nil,
      programs: List<ProgramProcedure>? = []) {
      self.id = id
      self.name = name
      self.description = description
      self.programs = programs
  }
}