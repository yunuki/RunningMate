//
//  MyPage+RecordViewModel.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/29.
//

import Foundation
import RxSwift
import RxCocoa

class MyPage_RecordViewModel: ViewModelType {
    private let useCase: RecordUseCase
    private let records = BehaviorRelay<[Record]>(value: [])
    private let isEnd = BehaviorRelay<Bool>(value: false)
    
    init(useCase: RecordUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let fetchFirstPageTrigger: Driver<Void>
    }
    
    struct Output {
        let fetchFirstPageTriggered: Driver<[Record]>
        let isLoading: Driver<Bool>
        let records: Driver<[Record]>
    }
    
    func transform(input: Input) -> Output {
        
        let activityIndicator = ActivityIndicator()
        
        let fetchFirstPageTriggered = input.fetchFirstPageTrigger
            .withLatestFrom(UserManager.shared.getUserRelay().asDriver())
            .compactMap{$0?.id}
            .flatMapLatest { [weak self] userId -> Driver<[Record]> in
                guard let `self` = self else {return Driver.just([])}
                return self.useCase.fetchRecords(queryParams: [
                    "account_id": userId,
                    "page": 0,
                    "limit": 10
                ])
                .trackActivity(activityIndicator)
                .asDriver(onErrorJustReturn: [])
            }
            .do(onNext: {[weak self] records in
                self?.isEnd.accept(records.count == 0)
                self?.records.accept(records)
            })
        
        return Output(
            fetchFirstPageTriggered: fetchFirstPageTriggered,
            isLoading: activityIndicator.asDriver(),
            records: records.asDriver()
        )
    }
}
