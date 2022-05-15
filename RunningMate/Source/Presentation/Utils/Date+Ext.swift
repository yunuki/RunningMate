//
//  Date+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/14.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
