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
                let sortedProcedures = procedures.sorted { $0.name < $1.name }
                if filterText.isEmpty {
                    return sortedProcedures
                } else {
                    return sortedProcedures.filter { procedure in
                        procedure.name.lowercased().contains(filterText.lowercased())
                    }
                }
            }
            .assign(to: \.filteredProcedures, on: self)
            .store(in: &cancelableSet)
    }
    
    //TODO: refactor into API module.
    func fetchProcedures(nextToken: String? = nil, procedureList: [Procedure] = []) {
        
        let query = ListProceduresQuery(limit:1000, nextToken: nextToken)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appSyncClient = appDelegate.appSyncClient
        appSyncClient?.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) {
            result, error in
            if let procedureItems = result?.data?.listProcedures?.items {
                let compactProcs = procedureItems.compactMap {
                    Procedure(id: ($0?.id)! , name: $0!.name, description: $0?.description)
                } + procedureList
                if let next = result?.data?.listProcedures?.nextToken {
                    self.fetchProcedures(nextToken: next, procedureList: compactProcs)
                }
                //TODO: remove this hack when we have editable procedures.
                self.procedures = compactProcs.filter({ (procedure) -> Bool in
                    !procedure.name.starts(with: "Invalid -")
                })
            }
        }
    }
    
}

struct ProcedureSelect: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedProcedure : Procedure?
    
    @ObservedObject var viewModel : ProcedureSelectViewModel
    
    func selectProcedure(_ procedure: Procedure) {
        selectedProcedure = procedure
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func fetchProcedures() {
        self.viewModel.fetchProcedures()
    }
    
    func doNothing() {
        return
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
        }
        .navigationBarTitle("Procedures")
        
    }
}

