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
    @Published var optionalProcedures : [Procedure] = []
    @Published var searchFilteredOptionalProcedures : [Procedure] = []
    @Published var assignedProcedures : [Procedure] = []
    @Published var searchFilteredAssignedProcedures : [Procedure] = []
    @Published var filterText : String = ""
    @Published var membershipProgramIds : [String] = []
    
    let procedureApi = ProcedureAPI()
    
    var cancelableSet : Set<AnyCancellable> = []
    
    fileprivate func sortAndFilterProcedures(_ optionalProcedures: [Procedure], _ filterText: String) -> [Procedure] {
        let sortedProcedures = optionalProcedures.sorted { $0.name < $1.name }
        if filterText.isEmpty {
            return sortedProcedures
        } else {
            return sortedProcedures.filter { procedure in
                procedure.name.lowercased().contains(filterText.lowercased())
            }
        }
    }
    
    init() {
        Publishers
            .CombineLatest($allProcedures, $membershipProgramIds)
            .receive(on: RunLoop.main)
            .map {
                allProcedures, membershipIds in
                
                return allProcedures.filter { proc in
                    return !proc.belongsToAnyPrograms(ids: membershipIds)
                }
            }
            .assign(to: \.optionalProcedures, on: self)
            .store(in: &cancelableSet)
        
        Publishers
            .CombineLatest($allProcedures, $membershipProgramIds)
            .receive(on: RunLoop.main)
            .map {
                allProcedures, membershipProgramIds in
                
                return allProcedures.filter { proc in
                    return proc.belongsToAnyPrograms(ids: membershipProgramIds)
                }
            }
            .assign(to: \.assignedProcedures, on: self)
            .store(in: &cancelableSet)
        
        Publishers
            .CombineLatest($optionalProcedures, $filterText)
            .receive(on: RunLoop.main)
            .map { [self] optionalProcedures, filterText in
                return self.sortAndFilterProcedures(optionalProcedures, filterText)
            }
            .assign(to: \.searchFilteredOptionalProcedures, on: self)
            .store(in: &cancelableSet)
        
        Publishers
            .CombineLatest($assignedProcedures, $filterText)
            .receive(on: RunLoop.main)
            .map { [self] assignedProcedures, filterText in
                return self.sortAndFilterProcedures(assignedProcedures, filterText)
            }
            .assign(to: \.searchFilteredAssignedProcedures, on: self)
            .store(in: &cancelableSet)
    }
    
    func fetchProcedures(user: User) {
        self.membershipProgramIds = user.memberships?.compactMap({ membership in
            return membership.program.id
        }) ?? []
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
