//
//  SignUpNavigator.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/17.
//

import UIKit

class SignUpNavigator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func setHomeAsRoot() {
        let window = self.navigationController?.topViewController?.view.window
        let nav = UINavigationController()
        let homeVC = HomeViewController(viewModel: HomeViewModel(navigator: HomeNavigator(navigationController: nav)))
        nav.pushViewController(homeVC, animated: false)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
