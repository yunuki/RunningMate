//
//  BaseViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/05.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        updateUI()
        self.navigationController?.initNaviBarWithBackButton()
    }
    
    func updateUI() {
        self.view.backgroundColor = .white
    }
    
    func setConstraints() {
        //should override
    }
}
