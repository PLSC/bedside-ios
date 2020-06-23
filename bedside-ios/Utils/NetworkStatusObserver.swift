//
//  NetworkStatus.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 6/23/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import Foundation
import Network

enum NetworkStatus {
    case offline
    case online
}

class NetworkStatusObserver : ObservableObject {
    let monitor : NWPathMonitor
    @Published var networkStatus : NetworkStatus = .offline
    
    init() {
        self.monitor = NWPathMonitor()
        self.monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                switch path.status {
                case .requiresConnection:
                    self.networkStatus = .offline
                case .satisfied:
                    self.networkStatus = .online
                case .unsatisfied:
                    self.networkStatus = .offline
                @unknown default:
                    self.networkStatus = .online
                }
            }
        }
        
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
}
