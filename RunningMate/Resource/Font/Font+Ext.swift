//
//  Font+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/14.
//

import UIKit

extension UIFont {
    enum Weight: String {
        case extraBold = "EB"
        case bold = "B"
        case regular = "R"
        case light = "L"
    }
    
    static func nanumRound(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont(name: "NanumSquareRoundOTF\(weight.rawValue)", size: size)!
    }
}
