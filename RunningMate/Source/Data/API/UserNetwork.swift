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
        return network.getItem("user", itemId: "\(userId)")
    }
    
    func getUsers() -> Observable<[User]> {
        return network.getItems("users")
    }
    
    func postUser(request: UserRequestModel) -> Observable<User> {
        return network.postItem("user", parameters: [
            "token": request.token,
            "name": request.name
        ])
    }
}
