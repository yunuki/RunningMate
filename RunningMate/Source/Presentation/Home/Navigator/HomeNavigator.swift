//
//  HomeNavigator.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/14.
//

import UIKit

class HomeNavigator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func pushRecordVC() {
        let vc = RecordStartViewController()
        self.navigationController?.topViewController?.present(vc, animated: true)
    }
}
