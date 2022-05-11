//
//  AuthNetwork.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/11.
//

import Foundation
import RxSwift

final class AuthNetwork {
    let network: Network<Auth>
    
    init(network: Network<Auth>) {
        self.network = network
    }
    
    func postAuth(token: String) -> Observable<Auth> {
        return network.postItem("auth", parameters: [
            "token": token
        ])
    }
}
