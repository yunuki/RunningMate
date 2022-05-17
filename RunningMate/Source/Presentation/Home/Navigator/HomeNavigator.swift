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
        let recordVC = RecordViewController(viewModel: RecordViewModel(navigator: RecordNavigator(presentingViewController: self.navigationController?.topViewController)))
        recordVC.modalPresentationStyle = .fullScreen
        self.navigationController?.topViewController?.present(recordVC, animated: true)
    }
}
