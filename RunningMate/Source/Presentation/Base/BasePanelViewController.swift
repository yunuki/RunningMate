//
//  BasePanelViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import UIKit

class BasePanelViewController: UIViewController {
    
    let panel: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
