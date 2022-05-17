//
//  UserNetwork.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import Foundation
import RxSwift

final class UserNetwork {
    let network: Network<User>
    
    init(network: Network<User>) {
        self.network = network
    }
    
    func getUser(userId: Int) -> Observable<User> {
        return network.getItem("account", itemId: "\(userId)")
    }
    
    func getUsers() -> Observable<[User]> {
        return network.getItems("account/list")
    }
    
    func putUser(userId: Int, nickname: String) -> Observable<User> {
        return network.updateItem("account", itemId: "\(userId)", parameters: [
            "nickname": nickname
        ])
    }
    
}
