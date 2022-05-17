//
//  RecordViewModel.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/14.
//

import Foundation
import RxSwift
import RxCocoa

class RecordViewModel: ViewModelType {
    
    private let navigator: RecordNavigator
    
    init(navigator: RecordNavigator) {
        self.navigator = navigator
    }
    
    struct Input {
        let endRunningBtnTapped: Driver<Void>
    }
    
    struct Output {
        let endRunning: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let endRunning = input.endRunningBtnTapped
            .do(onNext: {_ in RecordManager.shared.end()})
            .do(onNext: navigator.dismiss)
        return Output(
            endRunning: endRunning
        )
    }
}
