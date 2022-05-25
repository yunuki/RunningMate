//
//  RecordNavigator.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/14.
//

import UIKit

class RecordNavigator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func dismiss() {
        self.navigationController?.optionAlert("러닝을 중지하시겠습니까?", handler: { [weak self] _ in
            RecordManager.shared.end()
            self?.navigationController?.dismiss(animated: true)
        })
    }
}
