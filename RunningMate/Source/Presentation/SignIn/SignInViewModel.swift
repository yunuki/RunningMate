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
        let viewDidLoad: Driver<Void>
        let authCodeTrigger: Driver<String>
    }
    
    struct Output {
        let doAuth: Driver<Auth>
        let isLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let activityIndicator = ActivityIndicator()
        
        let doAuth = Driver.merge(
            input.viewDidLoad
                .compactMap{_ in UserDefaults.standard.string(forKey: UDKey.token)}
                .flatMapLatest { [weak self] token -> Driver<Auth> in
                    guard let `self` = self else {return Driver.empty()}
                    return self.authUseCase.auth(token: token)
                        .trackActivity(activityIndicator)
                        .asDriver(onErrorRecover: {_ in Driver.empty()})
                },
            input.authCodeTrigger
                .flatMapLatest { [weak self] code -> Driver<Auth> in
                    guard let `self` = self else {return Driver.empty()}
                    return self.authUseCase.auth(code: code)
                        .trackActivity(activityIndicator)
                        .asDriver(onErrorRecover: {_ in Driver.empty()})
                }
            )
            .do(onNext: {[weak self] auth in
                UserManager.shared.setUser(auth.user)
                UserDefaults.standard.set(auth.token, forKey: UDKey.token)
                if auth.isNew {
                    self?.navigator.pushSignUp()
                } else {
                    self?.navigator.setHomeAsRoot()
                }
            })
        
        return Output(
            doAuth: doAuth,
            isLoading: activityIndicator.asDriver()
        )
    }
}

