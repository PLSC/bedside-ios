// swiftlint:disable all
import Amplify
import Foundation

public enum Role: String, EnumPersistable {
  case user = "User"
  case programAdmin = "ProgramAdmin"
  case admin = "Admin"
}