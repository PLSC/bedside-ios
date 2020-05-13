//
//  CertificationRecord.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/5/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation

public struct CertificationRecord : Identifiable {
    public let id : String
    //public let subject : User
    
    public let procedure: Procedure
    public let isCertified: Bool
    public let certificationMethod: String?
    public let totalProcedureEvals: Int
    public var certificationLog: [EvaluationResponse]?
}

extension ListCertificationRecordsQuery.Data.ListCertificationRecord.Item.CertificationLog.Item.Subject: UserRepresentible {
    
}
extension ListCertificationRecordsQuery.Data.ListCertificationRecord.Item.CertificationLog.Item.Rater: UserRepresentible {
    
}

extension UsersByEmailQuery.Data.UsersByEmail.Item: UserRepresentible {
    
}

extension DateFormatter {
    static let AWS_DATE_TIME_STRING_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
}

extension Date {
    var awsDateTimeString : String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.AWS_DATE_TIME_STRING_FORMAT
            return dateFormatter.string(from: self)
        }
    }
}

extension String {
    var awsDateTime : Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.AWS_DATE_TIME_STRING_FORMAT
            return dateFormatter.date(from: self)
        }
    }
}

extension UserRepresentible {
    func mapToUser() -> User {
        return User(id: self.id, userName: self.userName, email: self.email, phone: self.phone, firstName: self.firstName, lastName: self.lastName, npi: self.npi, orgId: self.orgId)
    }
}



extension CertificationRecord {
    
    func map(userListItem: UserRepresentible?) -> User? {
        guard let user = userListItem else { return nil }
        return user.mapToUser()
    }
    
    func mapCertLogItem(_ certLogItem: ListCertificationRecordsQuery.Data.ListCertificationRecord.Item.CertificationLog.Item?) -> EvaluationResponse? {
        
        guard let eval = certLogItem,
            let subject = self.map(userListItem: eval.subject),
            let rater = self.map(userListItem: eval.rater),
            let ratingLevel = eval.ratingLevel,
            let evalDate = eval.evauluationDate.awsDateTime
            else { return nil }
                   
        let p = eval.procedure!
        let procedure = Procedure(id: p.id, name: p.name, description: p.description)
                   
        return EvaluationResponse(id: eval.id, subject: subject, rater: rater, procedure: procedure, evaluationDate: evalDate, ratingLevel: ratingLevel)
    }
    
    init(certificationRecordItem: ListCertificationRecordsQuery.Data.ListCertificationRecord.Item) {
        let p = certificationRecordItem.procedure
        let procedure = Procedure(id: p.id, name: p.name, description: p.description)
        
        self.id = certificationRecordItem.id
        self.procedure = procedure
        self.isCertified = certificationRecordItem.isCertified ?? false
        self.certificationMethod = certificationRecordItem.certificationMethod?.rawValue
        self.totalProcedureEvals = certificationRecordItem.totalProcedureEvals ?? 0
        self.certificationLog = []
        self.certificationLog = certificationRecordItem.certificationLog?.items?.compactMap(mapCertLogItem(_:))
    }
}
