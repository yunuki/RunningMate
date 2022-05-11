//
//  AuthUseCase.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/11.
//

import Foundation
import RxSwift

protocol AuthUseCase {
    func auth(token: String) -> Observable<Auth>
}

final class DefaultAuthUseCase: AuthUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func auth(token: String) -> Observable<Auth> {
        return authRepository.auth(token: token)
    }
}
