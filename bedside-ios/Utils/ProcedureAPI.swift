//
//  ProcedureAPI.swift
//  bedside-ios
//
//  Created by Sean Loiselle on 11/30/21.
//  Copyright © 2021 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit
import Amplify

enum ProcedureAPIError : Error {
    case MappingError
}

class ProcedureAPI  {
    

    func getProcedures(nextToken: String? = nil, procedureList: [Procedure] = []) async -> Result<[Procedure], Error> {
        while true {
            let request = buildUsersByEmailQuery(nextToken: nextToken)

            do {
                let result = try await Amplify.API.query(request: request)

                switch result {
                case .success(let record):
                    NSLog("Retrieve batch of Procedures succeed. \(record)")

                    var updatingProcedures = procedureList
                    updatingProcedures.append(contentsOf: record.items)

                    guard let nextToken = record.nextToken else {
                        if updatingProcedures.count > 0 {
                            let filteredProcedures = updatingProcedures.filter({
                                (procedure) -> Bool in
                                !procedure.name.starts(with: "Invalid -")
                            })
                            return .success(filteredProcedures)
                        } else {
                            return .failure(ProcedureAPIError.MappingError)
                        }
                    }

                    return await getProcedures(nextToken: nextToken, procedureList: updatingProcedures)
                case .failure(let error):
                    NSLog("Retrieve batch of Procedures failed: \(error.debugDescription)")
                    return .failure(error)
                }
            } catch let error as APIError {
                NSLog("Retrieve batch of Procedures failed: \(error.debugDescription)")
                return .failure(error)
            } catch {
                if Task.isCancelled {
                    NSLog("Retrieve batch of Procedures failed with Swift.CancellationError: \(error.localizedDescription)")
                    return .failure(error)
                } else {
                    NSLog("Retrieve batch of Procedures failed: \(error.localizedDescription)")
                    return .failure(error)
                }
            }
        }
    }
}

extension ProcedureAPI {

    private func buildUsersByEmailQuery(nextToken: String?) -> GraphQLRequest<ProceduresList> {

        var argumentValues = "limit: $limit"
        if let nextToken = nextToken {
            argumentValues += ", nextToken: " + #"""# + nextToken + #"""#
        }

        let query = """
            query ListProcedures($limit: Int) {
                   listProcedures(\(argumentValues)) {
                    __typename
                    items {
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
                                procedure {
                                    __typename
                                    id
                                    name
                                    description
                                    createdAt
                                    updatedAt
                                }
                                programId
                                program {
                                    __typename
                                    id
                                    name
                                    orgID
                                    description
                                    createdAt
                                    updatedAt
                                }
                                createdAt
                                updatedAt
                            }
                            nextToken
                        }
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
            responseType: ProceduresList.self,
            decodePath: "listProcedures"
        )
    }
}

extension ProcedureAPI {
    class ProceduresList: Model {
        let items: [Procedure]
        let nextToken: String?
    }
}
