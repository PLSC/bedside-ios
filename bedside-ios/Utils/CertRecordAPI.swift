//
//  CertRecordAPI.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/5/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit

enum CertRecordAPIError : Error {
    case MappingError
}

class CertRecordAPI  {
    
    typealias Handler = (Result<[CertificationRecord], Error>) -> Void
    
    func getCertRecords(subjectId: String, nextToken: String? = nil, callback: @escaping Handler, certRecordList: [CertificationRecord] = []) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        let subjectModelId = ModelIDInput(eq:subjectId)
        let filter = ModelCertificationRecordFilterInput(subjectId: subjectModelId)
        let query = ListCertificationRecordsQuery(filter: filter, limit: 1000, nextToken: nextToken)
        appSyncClient?.fetch(query: query,
                             cachePolicy: .returnCacheDataAndFetch,
                             resultHandler:{(result, error) in
            if let e = error {
                print("error fetching cert records: \(e.localizedDescription)")
                callback(.failure(e))
            }
                                
            if let certRecordItems = result?.data?.listCertificationRecords?.items {
                let certRecords : [CertificationRecord] = certRecordItems.compactMap(self.mapCertRecord) + certRecordList
                if let next = result?.data?.listCertificationRecords?.nextToken {
                    self.getCertRecords(subjectId: subjectId, nextToken: next, callback: callback, certRecordList: certRecords)
                }
                else {
                    callback(.success(certRecords))
                }
            } else {
                callback(.failure(CertRecordAPIError.MappingError))
            }
        })
    }
    
    //TODO: Map evaluation log & users (subject etc)s.
    func mapCertRecord(certRecordItem: ListCertificationRecordsQuery.Data.ListCertificationRecord.Item?) -> CertificationRecord? {
        guard let c = certRecordItem else { return nil }
        return CertificationRecord(certificationRecordItem: c)
    }
}
