// swiftlint:disable all
import Amplify
import Foundation

extension UserSettings {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case receiveWeeklyNewEvaluationsEmail
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userSettings = UserSettings.keys
    
    model.pluralName = "UserSettings"
    
    model.fields(
      .field(userSettings.receiveWeeklyNewEvaluationsEmail, is: .optional, ofType: .bool)
    )
    }
}