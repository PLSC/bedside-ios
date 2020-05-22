//
//  ProcedureSelect.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 3/26/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import Amplify
import Combine

class ProcedureSelectViewModel : ObservableObject {
    
    @Published var procedures : [Procedure] = []
    
    @Published var filteredProcedures : [Procedure] = []
    
    @Published var filterText : String = ""
    
    var cancelableSet : Set<AnyCancellable> = []
    
    
    init() {
        Publishers.CombineLatest($procedures, $filterText)
            .receive(on: RunLoop.main)
            .map {
                procedures, filterText in
                if filterText.isEmpty {
                    return procedures
                } else {
                    return procedures.filter { procedure in
                        procedure.name.lowercased().contains(filterText.lowercased())
                    }
                }
            }
            .assign(to: \.filteredProcedures, on: self)
            .store(in: &cancelableSet)
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
}

struct ProcedureSelect: View {
    @Binding var selectedProcedure : Procedure?
    
    @Binding var isPresented : Bool
    
    @ObservedObject var viewModel = ProcedureSelectViewModel()
    
    func selectProcedure(_ procedure: Procedure) {
        selectedProcedure = procedure
        isPresented = false
    }
    
    //TODO: refactor into API module.
    func fetchProcedures() {
        self.viewModel.fetchProcedures()
    }
    
    var body: some View {
        return VStack {
            SearchBar(text: $viewModel.filterText, placeholder: "Search Procedures")
            List(viewModel.filteredProcedures, id: \.id) { procedure in
                HStack {
                    Text("\(procedure.name)")
                        .frame(alignment: .leading)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.selectProcedure(procedure)
                }
            }
        }.onAppear {
            self.fetchProcedures()
        }.navigationBarTitle("Procedures")
    }
}

struct ProcedureSelect_Previews: PreviewProvider {
    static var previews: some View {
        ProcedureSelect(selectedProcedure: .constant(nil), isPresented: .constant(false))
    }
}
