//
//  CertRecordAPI.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/5/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit

class CertRecordAPI  {
    func getCertRecords(subjectId: String, callback: @escaping ([CertificationRecord]) ->()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        let subjectModelId = ModelIDInput(eq:subjectId)
        let filter = ModelCertificationRecordFilterInput(subjectId: subjectModelId)
        let query = ListCertificationRecordsQuery(filter: filter, limit: 100)
        appSyncClient?.fetch(query: query,
                             cachePolicy: .returnCacheDataAndFetch,
                             resultHandler:{(result, error) in
            if let e = error {
                print("error fetching cert records: \(e.localizedDescription)")
            }
                                
            if let certRecordItems = result?.data?.listCertificationRecords?.items {
                let certRecords : [CertificationRecord] = certRecordItems.compactMap(self.mapCertRecord)
                callback(certRecords)
            }
        })
    }
    
    //TODO: Map evaluation log & users (subject etc)s.
    func mapCertRecord(certRecordItem: ListCertificationRecordsQuery.Data.ListCertificationRecord.Item?) -> CertificationRecord? {
        guard let c = certRecordItem else { return nil }
        return CertificationRecord(certificationRecordItem: c)
    }
}
