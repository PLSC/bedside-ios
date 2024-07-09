// swiftlint:disable all
import Amplify
import Foundation

public enum InvitationStatus: String, EnumPersistable {
  case started = "Started"
  case notified = "Notified"
  case resolved = "Resolved"
}