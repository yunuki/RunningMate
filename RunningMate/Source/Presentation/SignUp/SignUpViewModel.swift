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
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    struct Input {
        let signUpBtnTapped: Driver<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        
        
        return Output()
    }
}
