//
//  NetworkProvider.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import Foundation

final class NetworkProvider {
    private let apiEndPoint: String
    
    init() {
        self.apiEndPoint = ""
    }
    
    func makeUsersNetwork() -> UsersNetwork {
        let network = Network<User>(apiEndPoint)
        return UsersNetwork(network: network)
    }
    
}
