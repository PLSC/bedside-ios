//
//  CertRecordAPI.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/5/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit
import Amplify

enum CertRecordAPIError : Error {
    case MappingError
}

class CertRecordAPI  {
    
//    typealias Handler = (Result<[CertificationRecord], Error>) -> Void
    
//    func getCertRecords(subjectId: String, nextToken: String? = nil, callback: @escaping Handler, certRecordList: [CertificationRecord] = []) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let appSyncPrivateClient = appDelegate.appSyncPrivateClient
//        let subjectModelId = ModelIDInput(eq:subjectId)
//        let filter = ModelCertificationRecordFilterInput(subjectId: subjectModelId)
//        let query = ListCertificationRecordsQuery(filter: filter, limit: 1000, nextToken: nextToken)
//        appSyncPrivateClient?.fetch(query: query,
//                             cachePolicy: .returnCacheDataAndFetch,
//                             resultHandler:{(result, error) in
//            if let e = error {
//                print("error fetching cert records: \(e.localizedDescription)")
//                callback(.failure(e))
//            }
//                                
//            if let certRecordItems = result?.data?.listCertificationRecords?.items {
//                let certRecords : [CertificationRecord] = certRecordItems.compactMap(self.mapCertRecord) + certRecordList
//                if let next = result?.data?.listCertificationRecords?.nextToken {
//                    self.getCertRecords(subjectId: subjectId, nextToken: next, callback: callback, certRecordList: certRecords)
//                }
//                else {
//                    callback(.success(certRecords))
//                }
//            } else {
//                callback(.failure(CertRecordAPIError.MappingError))
//            }
//        })
//    }
    
    //TODO: Map evaluation log & users (subject etc)s.
//    func mapCertRecord(certRecordItem: ListCertificationRecordsQuery.Data.ListCertificationRecord.Item?) -> CertificationRecord? {
//        guard let c = certRecordItem else { return nil }
//        return CertificationRecord(certificationRecordItem: c)
//    }

    func getCertRecords(subjectId: String, nextToken: String? = nil, certRecordList: [CertificationRecord] = []) async -> Result<[CertificationRecord], Error> {

        while true {
            let request = buildListCertificationRecordsQuery(subjectId: subjectId, nextToken: nextToken)

            do {
                let result = try await Amplify.API.query(request: request)

                switch result {
                case .success(let record):
                    NSLog("Retrieve batch of CertificationRecords succeed. \(record)")

                    var updatingCertificationRecords = certRecordList
                    updatingCertificationRecords.append(contentsOf: record.items)

                    guard let nextToken = record.nextToken else {
                        return .success(updatingCertificationRecords)
                    }

                    return await getCertRecords(subjectId: subjectId, nextToken: nextToken, certRecordList: updatingCertificationRecords)
                case .failure(let error):
                    NSLog("Retrieve batch of CertificationRecords failed: \(error.debugDescription)")
                    return .failure(error)
                }
            } catch let error as APIError {
                NSLog("Retrieve batch of CertificationRecords failed: \(error.debugDescription)")
                return .failure(error)
            } catch {
                if Task.isCancelled {
                    NSLog("Retrieve batch of CertificationRecords failed with Swift.CancellationError: \(error.localizedDescription)")
                    return .failure(error)
                } else {
                    NSLog("Retrieve batch of CertificationRecords failed: \(error.localizedDescription)")
                    return .failure(error)
                }
            }
        }
    }
}

extension CertRecordAPI {

    private func buildListCertificationRecordsQuery(subjectId: String, nextToken: String?) -> GraphQLRequest<CertificationRecordsList> {

        let formattedSubjectId = #"""# + subjectId + #"""#

        var argumentValues = "limit: $limit"
        if let nextToken = nextToken {
            argumentValues += ", nextToken: " + #"""# + nextToken + #"""#
        }

        argumentValues += ", filter: {subjectId: {eq: \(formattedSubjectId)}}"

        let query = """
            query ListCertificationRecords($limit: Int) {
                   listCertificationRecords(\(argumentValues)) {
                        __typename
                        items {
                            __typename
                            id
                            procedureId
                            procedure {
                                __typename
                                id
                                name
                                description
                                programs {
                                    __typename
                                    items {
                                        __typename
                                        id
                                        procedureId
                                        programId
                                        createdAt
                                        updatedAt
                                    }
                                    nextToken
                                }
                                createdAt
                                updatedAt
                            }
                            isCertified
                            certificationMethod
                            subjectId
                            subject {
                                __typename
                                id
                                orgID
                                userName
                                email
                                phone
                                firstName
                                lastName
                                npi
                                pgy
                                isRater
                                memberships {
                                    __typename
                                    items {
                                        __typename
                                        id
                                        role
                                        userId
                                        programId
                                        createdAt
                                        updatedAt
                                    }
                                    nextToken
                                }
                                createdAt
                                updatedAt
                        }
                        certificationLog {
                            __typename
                            items {
                                __typename
                                id
                                subject {
                                    __typename
                                    id
                                    orgID
                                    userName
                                    email
                                    phone
                                    firstName
                                    lastName
                                    npi
                                    pgy
                                    isRater
                                    createdAt
                                    updatedAt
                                }
                                subjectId
                                rater {
                                    __typename
                                    id
                                    orgID
                                    userName
                                    email
                                    phone
                                    firstName
                                    lastName
                                    npi
                                    pgy
                                    isRater
                                    createdAt
                                    updatedAt
                                }
                                raterId
                                procedure {
                                    __typename
                                    id
                                    name
                                    description
                                    createdAt
                                    updatedAt
                                }
                                procedureId
                                evaluationDate
                                ratingLevel
                                certificationRecordId
                                createdAt
                                updatedAt
                            }
                            nextToken
                        }
                        totalProcedureEvals
                        createdAt
                        updatedAt
                        }
                        nextToken
               }
             }
            """

        return GraphQLRequest(
            document: query,
            variables: ["limit": 1000],
            responseType: CertificationRecordsList.self,
            decodePath: "listCertificationRecords"
        )
    }
}

extension CertRecordAPI {
    class CertificationRecordsList: Model {
        let items: [CertificationRecord]
        let nextToken: String?
    }
}
