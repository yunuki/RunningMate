//
//  MyPageViewModel.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/28.
//

import Foundation
import RxSwift
import RxCocoa

class MyPageViewModel: ViewModelType {
    
    private let navigator: MyPageNavigator
    
    init(navigator: MyPageNavigator) {
        self.navigator = navigator
    }
    
    struct Input {
        
    }
    
    struct Output {
        let user: Driver<User>
    }
    
    func transform(input: Input) -> Output {
        return Output(
            user: UserManager.shared.getUserRelay()
                .compactMap{$0}
                .asDriver(onErrorRecover: {_ in Driver.empty()})
        )
    }
}
