//
//  CertificationRecord.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/5/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation

public struct CertificationRecord : Codable, Identifiable {
    public let id : String
    //public let subject : User
    public let procedure: Procedure
    public let isCertified: Bool
    public let certificationMethod: String?
    public let totalProcedureEvals: Int
}

extension CertificationRecord {
    init(certificationRecordItem: ListCertificationRecordsQuery.Data.ListCertificationRecord.Item) {
        let p = certificationRecordItem.procedure
        let procedure = Procedure(id: p.id, name: p.name, description: p.description)
       
        self.id = certificationRecordItem.id
        self.procedure = procedure
        self.isCertified = certificationRecordItem.isCertified ?? false
        self.certificationMethod = certificationRecordItem.certificationMethod?.rawValue
        self.totalProcedureEvals = certificationRecordItem.totalProcedureEvals ?? 0
    }
}
