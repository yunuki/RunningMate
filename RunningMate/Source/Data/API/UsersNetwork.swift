//
//  UsersNetwork.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import Foundation
import RxSwift

final class UsersNetwork {
    let network: Network<User>
    
    init(network: Network<User>) {
        self.network = network
    }
    
    func fetchUser(userId: Int) -> Observable<User> {
        return network.getItem("user", itemId: "\(userId)")
    }
}
