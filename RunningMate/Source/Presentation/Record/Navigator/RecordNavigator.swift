//
//  RecordNavigator.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/14.
//

import UIKit

class RecordNavigator {
    weak var presentingViewController: UIViewController?
    
    init(presentingViewController: UIViewController?) {
        self.presentingViewController = presentingViewController
    }
    
    func dismiss() {
        self.presentingViewController?.presentedViewController?.dismiss(animated: true)
    }
}
