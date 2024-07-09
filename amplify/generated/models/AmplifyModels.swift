// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "2bb8799900a59da83f1f28ce43d72480"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Organization.self)
    ModelRegistry.register(modelType: Program.self)
    ModelRegistry.register(modelType: Membership.self)
    ModelRegistry.register(modelType: Procedure.self)
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: EvaluationResponse.self)
    ModelRegistry.register(modelType: CertificationRecord.self)
    ModelRegistry.register(modelType: UserInvitation.self)
    ModelRegistry.register(modelType: ProgramProcedure.self)
  }
}