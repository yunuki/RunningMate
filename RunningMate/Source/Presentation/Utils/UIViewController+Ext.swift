//
//  UIViewController+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/13.
//

import UIKit

extension UIViewController {
    func alert(_ message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    func optionAlert(_ message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: handler))
        self.present(alert, animated: true)
    }
}
