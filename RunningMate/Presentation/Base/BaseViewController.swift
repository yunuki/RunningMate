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
        updateUI()
    }
    
    func updateUI() {
        self.view.backgroundColor = .white
    }
}
