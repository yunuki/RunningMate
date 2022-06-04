//
//  NetworkProvider.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import Foundation

final class NetworkProvider {
    static let shared = NetworkProvider()
    private let apiEndPoint: String
    
    init() {
        self.apiEndPoint = "http://3.39.155.242:8000"
//        self.apiEndPoint = "http://127.0.0.1:8000"
    }
    
    func makeAuthNetwork() -> AuthNetwork {
        let network = Network<Auth>(apiEndPoint)
        return AuthNetwork(network: network)
    }
    
    func makeUserNetwork() -> UserNetwork {
        let network = Network<User>(apiEndPoint)
        return UserNetwork(network: network)
    }
    
    func makeRecordNetwork() -> RecordNetwork {
        let network = Network<Record>(apiEndPoint)
        return RecordNetwork(network: network)
    }
    
    func makeRecordStatisticsNetwork() -> RecordStatisticsNetwork {
        let network = Network<RecordStatistics>(apiEndPoint)
        return RecordStatisticsNetwork(network: network)
    }
}
