//
//  ProcedureViewModel.swift
//  bedside-ios
//
//  Created by Sean Loiselle on 11/30/21.
//  Copyright © 2021 Andrew Lenox. All rights reserved.
//

import Foundation
import Combine

class ProcedureSelectViewModel : ObservableObject {
    
    @Published var allProcedures : [Procedure] = []
    @Published var filteredProcedures : [Procedure] = []
    @Published var filterText : String = ""
    
    let procedureApi = ProcedureAPI()
    var cancelableSet : Set<AnyCancellable> = []
    
    init() {
        Publishers.CombineLatest($allProcedures, $filterText)
            .receive(on: RunLoop.main)
            .map {
                allProcedures, filterText in
                let sortedProcedures = allProcedures.sorted { $0.name < $1.name }
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
    
    func fetchProcedures() {
        procedureApi.getProcedures() {
            result in
                switch result {
                case .success(let procs):
                    self.allProcedures = procs
                case .failure(let error):
                    print("Error fetching Procedures: \(error)")
                }
        }
    }
}
