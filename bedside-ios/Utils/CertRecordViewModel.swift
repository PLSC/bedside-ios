//
//  CertRecordViewModel.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 6/11/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import Combine

class CertRecordViewModel : ObservableObject {
    @Published var allCertificationRecords: [CertificationRecord] = []
    @Published var certified: [CertificationRecord] = []
    @Published var notCertified: [CertificationRecord] = []
    @Published var showEmptyView: Bool = true
    
    private var cancellableSet : Set<AnyCancellable> = []
    
    init() {
        $allCertificationRecords.receive(on: RunLoop.main).map { certRecords in
            return certRecords.filter { $0.isCertified }.sorted { $0.procedure.name < $1.procedure.name }
        }
        .assign(to: \.certified, on: self)
        .store(in: &cancellableSet)
        
        $allCertificationRecords.receive(on: RunLoop.main).map { certRecords in
            return certRecords.filter { !$0.isCertified }.sorted { $0.procedure.name < $1.procedure.name }
        }
        .assign(to: \.notCertified, on: self)
        .store(in: &cancellableSet)
        
        $allCertificationRecords.receive(on: RunLoop.main).map { certRecords in
            return certRecords.isEmpty
        }
        .assign(to: \.showEmptyView, on: self)
        .store(in: &cancellableSet)
    }
}
