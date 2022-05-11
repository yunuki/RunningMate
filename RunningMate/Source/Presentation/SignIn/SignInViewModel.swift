//
//  SignInViewModel.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/11.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel: ViewModelType {
    
    private let authUseCase: AuthUseCase
    private let navigator: SignInNavigator
    
    init(authUseCase: AuthUseCase, navigator: SignInNavigator) {
        self.authUseCase = authUseCase
        self.navigator = navigator
    }
    
    struct Input {
        let authTokenTrigger: Driver<String>
    }
    
    struct Output {
        let doAuth: Driver<User?>
    }
    
    func transform(input: Input) -> Output {
        
        let doAuth = input.authTokenTrigger
            .flatMapLatest { [weak self] token -> Driver<User?> in
                guard let `self` = self else {return Driver.empty()}
                return self.authUseCase.auth(token: token)
                    .map{$0.user}
                    .asDriver(onErrorJustReturn: nil)
            }
            .do(onNext: {[weak self] user in
                if let _ = user {
                    self?.navigator.setHomeAsRoot()
                } else {
                    self?.navigator.pushSignUp()
                }
            })
        
        return Output(
            doAuth: doAuth
        )
    }
}

