// swiftlint:disable all
import Amplify
import Foundation

public struct Procedure: Model, Identifiable, Codable {
    public let id: String
    public var name: String
    public var description: String?
    public var programs: [String]

    public init(id: String = UUID().uuidString,
      name: String,
      description: String? = nil,
      programs: [String] = []) {
      self.id = id
      self.name = name
      self.description = description
      self.programs = programs
    }
}

extension Procedure {
    public func belongsToProgram(id: String) -> Bool {
        self.programs.contains(id)
    }
    
    public func belongsToAnyPrograms(ids: [String]) -> Bool {
        !Set(ids).intersection(Set(self.programs)).isEmpty
    }
}
