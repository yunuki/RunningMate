//
//  UserRepository.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/11.
//

import Foundation
import RxSwift

protocol UserRepository {
    func user(userId: Int) -> Observable<User>
    func users() -> Observable<[User]>
    func update(userId: Int, nickname: String) -> Observable<User>
}

final class DefaultUserRepository: UserRepository {
    
    private let userNetwork: UserNetwork
    
    init(userNetwork: UserNetwork) {
        self.userNetwork = userNetwork
    }
    
    func user(userId: Int) -> Observable<User> {
        return userNetwork.getUser(userId: userId)
    }
    
    func users() -> Observable<[User]> {
        return userNetwork.getUsers()
    }
    
    func update(userId: Int, nickname: String) -> Observable<User> {
        return userNetwork.putUser(userId: userId, nickname: nickname)
    }
}
