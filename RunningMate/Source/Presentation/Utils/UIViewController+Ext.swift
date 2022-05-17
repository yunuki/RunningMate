//
//  UIViewController+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/13.
//

import UIKit

extension UIViewController {
    func alert(_ message: String) {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: message, style: .default))
        self.present(alert, animated: true)
    }
}
