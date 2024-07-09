// swiftlint:disable all
import Amplify
import Foundation

public enum Permission: String, EnumPersistable {
  case users = "Users"
  case programAdmins = "ProgramAdmins"
  case admins = "Admins"
  case sysadmins = "Sysadmins"
}