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
            let evalDate = eval.evaluationDate.awsDateTime
            else { return nil }
                   
        if let p = eval.procedure {
            let procedure = Procedure(id: p.id, name: p.name, description: p.description)
                       
            return EvaluationResponse(id: eval.id, subject: subject, rater: rater, procedure: procedure, evaluationDate: evalDate, ratingLevel: ratingLevel)
        } else {
            print("could not map procedure in certLogItem")
            return nil
        }
        
    }
    
    init?(certificationRecordItem: ListCertificationRecordsQuery.Data.ListCertificationRecord.Item) {
        guard let p = certificationRecordItem.procedure else { return nil }
        
        let procedureId = p.id
        let procedure = Procedure(id: procedureId, name: p.name, description: p.description)
        
        self.id = certificationRecordItem.id
        self.procedure = procedure
        self.isCertified = certificationRecordItem.isCertified ?? false
        self.certificationMethod = certificationRecordItem.certificationMethod?.rawValue
        self.totalProcedureEvals = certificationRecordItem.totalProcedureEvals ?? 0
        self.certificationLog = []
        self.certificationLog = certificationRecordItem.certificationLog?.items.compactMap(mapCertLogItem(_:))
    }
}
