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
        
        let _ = Amplify.API.query(from: Procedure.self, where: nil) { event in
            switch event {
            case .completed(let result):
                switch result {
                case .success(let procedures):
                    self.procedures = procedures
                default:
                    //TODO: handle errors
                    print("aww nuts")
                }
                
            case .failed(let error):
                print(error)
            default:
                print("unexepcted error")
            
            }
        }
    }
    
    var body: some View {
        return List(procedures) { procedure in
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
