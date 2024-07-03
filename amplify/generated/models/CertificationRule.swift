// swiftlint:disable all
import Amplify
import Foundation

public struct CertificationRule: Embeddable {
  var id: String
  var organization: Organization?
  var program: Program?
  var numOfEvals: Int?
  var atLevel: Int?
  var procedure: Procedure?
}