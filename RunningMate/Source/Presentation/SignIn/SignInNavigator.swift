//
//  SignInNavigator.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/11.
//

import UIKit

class SignInNavigator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func pushSignUp() {
        let signUpVC = SignUpViewController()
        self.navigationController?.pushViewController(signUpVC, animated: true)
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
