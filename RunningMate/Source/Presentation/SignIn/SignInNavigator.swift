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
        
    }
    
    func setHomeAsRoot() {
        let window = self.navigationController?.topViewController?.view.window
        let homeVC = HomeViewController(viewModel: HomeViewModel())
        let nav = UINavigationController(rootViewController: homeVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
