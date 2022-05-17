//
//  UIColor+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/17.
//

import UIKit

extension UIColor {
    static func setGray(_ value: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        let rgbValue: CGFloat
        if value == 0 { rgbValue = 0 }
        else{ rgbValue = value/CGFloat(255)}
        let color = UIColor(red: rgbValue, green: rgbValue, blue: rgbValue, alpha: alpha)
        return color
    }
}
