// swiftlint:disable all
import Amplify
import Foundation

public struct ProgramProcedure: Model {
  public let id: String
  public var procedure: Procedure
  public var program: Program
  
  public init(id: String = UUID().uuidString,
      procedure: Procedure,
      program: Program) {
      self.id = id
      self.procedure = procedure
      self.program = program
  }
}