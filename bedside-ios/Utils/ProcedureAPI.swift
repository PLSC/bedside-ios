//
//  ProcedureAPI.swift
//  bedside-ios
//
//  Created by Sean Loiselle on 11/30/21.
//  Copyright © 2021 Andrew Lenox. All rights reserved.
//

import Foundation
import UIKit

enum ProcedureAPIError : Error {
    case MappingError
}

class ProcedureAPI  {
    
    typealias Handler = (Result<[Procedure], Error>) -> Void
    
    func getProcedures(nextToken: String? = nil, callback: @escaping Handler, procedureList: [Procedure] = []) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        let query = ListProceduresQuery(limit:1000, nextToken: nextToken)
        appSyncClient?.fetch(query: query,
                             cachePolicy: .returnCacheDataAndFetch,
                             resultHandler:{(result, error) in
            if let e = error {
                print("error fetching procedures: \(e.localizedDescription)")
                callback(.failure(e))
            }
                                
            if let procedureItems = result?.data?.listProcedures?.items {
                let procedures : [Procedure] = procedureItems.compactMap(self.mapProcedure) + procedureList
                if let next = result?.data?.listProcedures?.nextToken {
                    self.getProcedures(nextToken: next, callback: callback, procedureList: procedures)
                }
                else {
                    let filteredProcedures = procedures.filter({ (procedure) -> Bool in
                        !procedure.name.starts(with: "Invalid -")
                    })
                    callback(.success(filteredProcedures))
                }
            } else {
                callback(.failure(ProcedureAPIError.MappingError))
            }
        })
    }
    
    func mapProcedure(procedureItem: ListProceduresQuery.Data.ListProcedure.Item?) -> Procedure? {
        var programMemberships : [String] = []
        programMemberships = procedureItem?.programs?.items.map { item in
            return item.program.id
        } ?? []
        return Procedure(id: (procedureItem?.id)! , name: procedureItem!.name, description: procedureItem?.description, programs: programMemberships)
    }
}
