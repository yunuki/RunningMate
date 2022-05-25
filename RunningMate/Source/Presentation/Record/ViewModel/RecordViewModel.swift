//
//  RecordViewModel.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/14.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class RecordViewModel: ViewModelType {
    
    private let navigator: RecordNavigator
    private let dayOrNight: RecordStartViewController.DayOrNight
    private let insideOrOutside: RecordStartViewController.InsideOrOutside
    private let time = BehaviorRelay<TimeInterval>(value: .zero)
    private let distance = BehaviorRelay<Double>(value: 0.0)
    private let kcal = BehaviorRelay<Double>(value: 0.0)
    private let pace = BehaviorRelay<Double>(value: 0.0)
    private let isPaused = BehaviorRelay<Bool>(value: false)
    
    init(
        dayOrNight: RecordStartViewController.DayOrNight,
        insideOrOutside: RecordStartViewController.InsideOrOutside,
        navigator: RecordNavigator
    ) {
        self.dayOrNight = dayOrNight
        self.insideOrOutside = insideOrOutside
        self.navigator = navigator
        RecordManager.shared.delegate = self

    }
    
    struct Input {
        let viewDidLoad: Driver<Void>
        let pauseOrResumeBtnTapped: Driver<Void>
        let endRunningBtnTapped: Driver<Void>
    }
    
    struct Output {
        let startRunning: Driver<Void>
        let time: Driver<Double>
        let distance: Driver<Double>
        let kcal: Driver<Double>
        let pace: Driver<Double>
        let isPaused: Driver<Bool>
        let pauseOrResumeRunning: Driver<Bool>
        let endRunning: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let startRunning = input.viewDidLoad
            .do(onNext: RecordManager.shared.start)
                
        let pauseOrResumeRunning = input.pauseOrResumeBtnTapped
            .withLatestFrom(isPaused.asDriver())
            .do(onNext: {[weak self] isPaused in
                self?.isPaused.accept(!isPaused)
                if isPaused {
                    RecordManager.shared.resume()
                } else {
                    RecordManager.shared.pause()
                }
            })
        
        let endRunning = input.endRunningBtnTapped
            .do(onNext: navigator.dismiss)
                
        return Output(
            startRunning: startRunning,
            time: time.asDriver(),
            distance: distance.asDriver(),
            kcal: kcal.asDriver(),
            pace: pace.asDriver(),
            isPaused: isPaused.asDriver(),
            pauseOrResumeRunning: pauseOrResumeRunning,
            endRunning: endRunning
        )
    }
}

extension RecordViewModel: RecordManagerDelegate {
    func didDistanceChanged(distance: Double) {
        let modified = round((distance / 1000) * 100) / 100
        self.distance.accept(modified)
    }
    
    func didKcalChanged(kcal: Double) {
        self.kcal.accept(kcal)
    }
    
    func didPaceChanged(pace: Double) {
        let modified = round(pace * 100) / 100
        self.pace.accept(modified)
    }
    
    func didTimeChanged(time: TimeInterval) {
        self.time.accept(time)
    }
    
}
