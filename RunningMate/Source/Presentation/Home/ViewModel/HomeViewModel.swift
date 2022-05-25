//
//  HomeViewModel.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType {
    
    private let navigator: HomeNavigator
    
    init(navigator: HomeNavigator) {
        self.navigator = navigator
    }
    
    struct Input {
        let startRunningBtnTapped: Driver<Void>
    }
    
    struct Output {
        let pushRecordVC: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let pushRecordVC = input.startRunningBtnTapped
            .do(onNext: navigator.pushRecordVC)
        
        return Output(
            pushRecordVC: pushRecordVC
        )
    }
}
