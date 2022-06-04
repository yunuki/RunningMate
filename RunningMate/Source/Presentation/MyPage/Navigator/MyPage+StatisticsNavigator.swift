//
//  MyPage+StatisticsNavigator.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/06/02.
//

import UIKit
import RxSwift

class MyPage_StatisticsNavigator {
    weak var navigationController: UINavigationController?
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func presentYearMonthSelectPanelVC(trigger: PublishSubject<Date>) {
        let vc = YearMonthSelectPanelViewController()
        vc.dateSelectTrigger = trigger
        self.navigationController?.topViewController?.present(vc, animated: true)
    }
}
