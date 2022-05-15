//
//  UIView+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/14.
//

import UIKit

extension UIView {
    func circleCorner() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height/2
    }
    
    func roundCorner(_ radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
}
