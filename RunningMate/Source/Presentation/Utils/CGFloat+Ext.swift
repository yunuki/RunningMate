//
//  CGFloat+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/16.
//

import UIKit

extension CGFloat {
    var adjusted: CGFloat {
        return self * UIScreen.main.bounds.width / CGFloat(375)
    }
}
