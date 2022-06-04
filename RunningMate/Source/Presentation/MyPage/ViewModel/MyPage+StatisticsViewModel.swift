//
//  MyPage+StatisticsViewModel.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/31.
//

import Foundation
import RxSwift
import RxCocoa

class MyPage_StatisticsViewModel: ViewModelType {
    private let useCase: RecordStatisticsUseCase
    private let navigator: MyPage_StatisticsNavigator
    private let selectedYearMonth = BehaviorRelay<(Int, Int)?>(value: nil)
    private let dateSelectTrigger = PublishSubject<Date>()
    
    init(useCase: RecordStatisticsUseCase, navigator: MyPage_StatisticsNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    struct Input {
        let viewDidLoad: Driver<Void>
        let openYearMonthPickerTrigger: Driver<Void>
    }
    
    struct Output {
        let totalAccumulate: Driver<RecordStatistics>
        let totalAverage: Driver<RecordStatistics>
        let openYearMonthPickerTriggered: Driver<PublishSubject<Date>>
        let dateSelectTriggered: Driver<(Int, Int)?>
        let selectedYearMonth: Driver<(Int, Int)?>
        let selectedAverage: Driver<RecordStatistics>
    }
    
    func transform(input: Input) -> Output {
        
        let totalAccumulate = input.viewDidLoad
            .withLatestFrom(UserManager.shared.getUserRelay().asDriver())
            .flatMapLatest { [weak self] user -> Driver<RecordStatistics> in
                guard let `self` = self,
                      let userId = user?.id else {return Driver.empty()}
                return self.useCase.fetchRecordStatistics(userId: userId, year: nil, month: nil, isAverage: false)
                    .asDriver(onErrorRecover: {_ in Driver.empty()})
            }
        
        let openYearMonthPickerTriggered = input.openYearMonthPickerTrigger
            .map{[unowned self] _ in
                return self.dateSelectTrigger
            }
            .do(onNext: navigator.presentYearMonthSelectPanelVC)
        
        let dateSelectTriggered = dateSelectTrigger
            .asDriver(onErrorRecover: {_ in Driver.empty()})
            .startWith(Date())
            .map { date -> (Int, Int)? in
                var calendar = Calendar.current
                calendar.locale = Locale(identifier: "ko_kr")
                calendar.timeZone = TimeZone(abbreviation: "KST")!
                let dateComponents = calendar.dateComponents([.year, .month], from: date)
                guard let year = dateComponents.year,
                      let month = dateComponents.month else {return nil}
                return (year, month)
            }
            .do(onNext: selectedYearMonth.accept(_:))
                
        let totalAverage = input.viewDidLoad
            .withLatestFrom(UserManager.shared.getUserRelay().asDriver())
            .flatMapLatest { [weak self] user -> Driver<RecordStatistics> in
                guard let `self` = self,
                      let userId = user?.id else {return Driver.empty()}
                return self.useCase.fetchRecordStatistics(userId: userId, year: nil, month: nil, isAverage: true)
                    .asDriver(onErrorRecover: {_ in Driver.empty()})
            }
                
        let selectedAverage = selectedYearMonth.asDriver()
            .withLatestFrom(UserManager.shared.getUserRelay().asDriver(), resultSelector: {($0, $1)})
            .flatMapLatest { [weak self] args, user -> Driver<RecordStatistics> in
                guard let `self` = self,
                      let userId = user?.id,
                      let (year, month) = args else {return Driver.empty()}
                return self.useCase.fetchRecordStatistics(userId: userId, year: year, month: month, isAverage: true)
                    .asDriver(onErrorJustReturn: RecordStatistics(userId: userId, year: year, month: month, distance: 0, duration: 0, pace: 0, kcal: 0))
            }
        
        return Output(
            totalAccumulate: totalAccumulate,
            totalAverage: totalAverage,
            openYearMonthPickerTriggered: openYearMonthPickerTriggered,
            dateSelectTriggered: dateSelectTriggered,
            selectedYearMonth: selectedYearMonth.asDriver(),
            selectedAverage: selectedAverage
        )
    }
}
