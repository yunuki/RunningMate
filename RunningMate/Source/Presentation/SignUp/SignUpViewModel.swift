//
//  SignUpViewModel.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/16.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    private let userUseCase: UserUseCase
    private let navigator: SignUpNavigator
    final let maxNicknameLength = 10
    final let minNicknameLength = 2
    
    init(userUseCase: UserUseCase, navigator: SignUpNavigator) {
        self.userUseCase = userUseCase
        self.navigator = navigator
    }
    
    struct Input {
        let nickname: Driver<String?>
        let saveBtnTapped: Driver<Void>
    }
    
    struct Output {
        let isNicknameValid: Driver<Bool>
        let save: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let isNicknameValid = input.nickname
            .compactMap { [weak self] nickname -> Bool? in
                guard let nickname = nickname, nickname != "" else {return false}
                return self?.validateNickname(nickname)
            }
        
        let save = input.saveBtnTapped
            .withLatestFrom(isNicknameValid)
            .filter{$0}
            .withLatestFrom(Driver.combineLatest(
                UserManager.shared.getUserRelay().asDriver().map{$0?.id},
                input.nickname
            ))
            .flatMapLatest { [weak self] userId, newNickname -> Driver<User> in
                guard let `self` = self,
                      let userId = userId,
                      let newNickname = newNickname else {return Driver.empty()}
                return self.userUseCase.updateUser(userId: userId, nickname: newNickname)
                    .asDriver(onErrorRecover: {_ in Driver.empty()})
            }
            .do(onNext: UserManager.shared.setUser(_:))
            .map{_ in}
            .do(onNext: navigator.setHomeAsRoot)
        
        return Output(
            isNicknameValid: isNicknameValid,
            save: save
        )
    }
    
    func validateNickname(_ nickname: String) -> Bool {
        let RegEx = "\\w{\(self.minNicknameLength),\(self.maxNicknameLength)}"
        return NSPredicate(format:"SELF MATCHES %@", RegEx).evaluate(with: nickname)
    }
}
