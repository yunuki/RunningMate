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
    private let userUseCase = DefaultUserUseCase(userRepository: DefaultUserRepository(userNetwork: NetworkProvider.shared.makeUserNetwork()))
    private let disposeBag = DisposeBag()
    
    func getUserSnapShot() -> User? {
        return self.user.value
    }
    
    func getUserRelay() -> BehaviorRelay<User?> {
        return self.user
    }
    
    func setUser(_ user: User?) {
        self.user.accept(user)
    }
    
    func reloadUser() {
        guard let userId = self.user.value?.id else {return}
        userUseCase.fetchUser(userId: userId)
            .subscribe(onNext: user.accept(_:))
            .disposed(by: disposeBag)
    }
}
