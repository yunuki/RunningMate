//
//  AuthRepository.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/11.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func auth(code: String) -> Observable<Auth>
    func auth(token: String) -> Observable<Auth>
}

final class DefaultAuthRepository: AuthRepository {
    private let authNetwork: AuthNetwork
    
    init(authNetwork: AuthNetwork) {
        self.authNetwork = authNetwork
    }
    
    func auth(code: String) -> Observable<Auth> {
        return authNetwork.postAuth(code: code)
    }
    
    func auth(token: String) -> Observable<Auth> {
        return authNetwork.postAuth(token: token)
    }
}
