//
//  ProcedureSelect.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/26/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import Amplify

struct ProcedureSelect: View {
    
    @State var procedures : [Procedure] = []
    
    @Binding var selectedProcedure : Procedure?
    
    @Binding var isPresented : Bool
    
    func selectProcedure(_ procedure: Procedure) {
        selectedProcedure = procedure
        isPresented = false
    }
    
    //TODO: refactor into API module.
    func fetchProcedures() {
        
        let query = ListProceduresQuery()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        appSyncClient?.fetch(query: query) {
            result, error in
            if let procedureItems = result?.data?.listProcedures?.items {
                self.procedures = procedureItems.compactMap {
                    Procedure(id: ($0?.id)! , name: $0!.name, description: $0?.description)
                }
            }
        }
    }
    
    var body: some View {
        return List(procedures, id: \.id) { procedure in
            Button(action: { self.selectProcedure(procedure)}) {
                Text("\(procedure.name)")
            }
            
        }.onAppear {
            self.fetchProcedures()
        }
    }
}

struct ProcedureSelect_Previews: PreviewProvider {
    static var previews: some View {
        ProcedureSelect(procedures: [], selectedProcedure: .constant(nil), isPresented: .constant(false))
    }
}
