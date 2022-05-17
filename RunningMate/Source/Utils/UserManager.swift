//
//  UserManager.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/16.
//

import Foundation
import RxSwift
import RxCocoa

final class UserManager {
    static let shared = UserManager()
    private let user = BehaviorRelay<User?>(value: nil)
    
    func getUserSnapShot() -> User? {
        return self.user.value
    }
    
    func getUserRelay() -> BehaviorRelay<User?> {
        return self.user
    }
    
    func setUser(_ user: User?) {
        self.user.accept(user)
    }
}
