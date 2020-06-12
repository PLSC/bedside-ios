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
    @Published var certificationRecords: [CertificationRecord] = []
    @Published var certifiedRecords: [CertificationRecord] = []
    @Published var notCertified: [CertificationRecord] = []
    @Published var showEmptyView: Bool = true
    
    private var cancellableSet : Set<AnyCancellable> = []
    
    init() {
        $certificationRecords.receive(on: RunLoop.main).map { certRecords in
            return certRecords.filter { $0.isCertified }.sorted { $0.procedure.name < $1.procedure.name }
        }
        .assign(to: \.certifiedRecords, on: self)
        .store(in: &cancellableSet)
        
        $certificationRecords.receive(on: RunLoop.main).map { certRecords in
            return certRecords.filter { !$0.isCertified }.sorted { $0.procedure.name < $1.procedure.name }
        }
        .assign(to: \.notCertified, on: self)
        .store(in: &cancellableSet)
        
        $certifiedRecords.receive(on: RunLoop.main).map { certRecords in
            return certRecords.isEmpty
        }
        .assign(to: \.showEmptyView, on: self)
        .store(in: &cancellableSet)
    }
}
