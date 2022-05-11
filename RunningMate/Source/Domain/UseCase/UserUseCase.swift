//
//  UserUseCase.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/11.
//

import Foundation
import RxSwift

protocol UserUseCase {
    func fetchUser(userId: Int) -> Observable<User>
    func fetchUsers() -> Observable<[User]>
    func createUser(request: UserRequestModel) -> Observable<User>
}

final class DefaultUserUseCase: UserUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetchUser(userId: Int) -> Observable<User> {
        return userRepository.user(userId: userId)
    }
    
    func fetchUsers() -> Observable<[User]> {
        return userRepository.users()
    }
    
    func createUser(request: UserRequestModel) -> Observable<User> {
        return userRepository.create(request: request)
    }
}
