//
//  UIStackView+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/25.
//

import UIKit

extension UIStackView {
    func addVerticalSeparators(color : UIColor) {
        
        func createSeparator(color : UIColor) -> UIView {
            let separator = UIView()
            separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
            separator.backgroundColor = color
            return separator
        }
        
        var i = self.arrangedSubviews.count - 1
        while i > 0 {
            let separator = createSeparator(color: color)
            insertArrangedSubview(separator, at: i)
            separator.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
            i -= 1
        }
    }

}
