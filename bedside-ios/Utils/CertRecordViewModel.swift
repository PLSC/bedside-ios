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
    @Published var showEmptyView: Bool = false
    @Published var loading: Bool = true
    
    let certRecordApi = CertRecordAPI()
    
    private var cancellableSet : Set<AnyCancellable> = []
    
    init() {
        $allCertificationRecords.receive(on: RunLoop.main).map { certRecords in
            return certRecords.filter { $0.isCertified ?? false }.sorted { $0.procedure?.name ?? "" < $1.procedure?.name ?? "" }
        }
        .assign(to: \.certified, on: self)
        .store(in: &cancellableSet)
        
        $allCertificationRecords.receive(on: RunLoop.main).map { certRecords in
            return certRecords.filter { !($0.isCertified ?? false) }.sorted { $0.procedure?.name ?? "" < $1.procedure?.name ?? "" }
        }
        .assign(to: \.notCertified, on: self)
        .store(in: &cancellableSet)
        
        $allCertificationRecords.receive(on: RunLoop.main).map { certRecords in
            return certRecords.isEmpty
        }
        .assign(to: \.showEmptyView, on: self)
        .store(in: &cancellableSet)
    }
    
    func fetchCertRecords(user: User) async {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.loading = true
        }

        let result = await certRecordApi.getCertRecords(subjectId: user.id)

        switch result {
        case .success(let certRecords):
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.allCertificationRecords = certRecords
                self.loading = false
            }
        case .failure(let error):
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.loading = false
            }
        }
    }
}
