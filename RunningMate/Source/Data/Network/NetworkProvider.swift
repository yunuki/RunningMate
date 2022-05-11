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
        self.apiEndPoint = ""
    }
    
    func makeAuthNetwork() -> AuthNetwork {
        let network = Network<Auth>(apiEndPoint)
        return AuthNetwork(network: network)
    }
    
    func makeUsersNetwork() -> UserNetwork {
        let network = Network<User>(apiEndPoint)
        return UserNetwork(network: network)
    }
    
}
