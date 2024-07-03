// swiftlint:disable all
import Amplify
import Foundation

public enum CertificationMethod: String, EnumPersistable {
  case manual = "Manual"
  case certificationRule = "CertificationRule"
}