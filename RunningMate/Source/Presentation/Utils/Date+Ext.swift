//
//  Date+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/14.
//

import Foundation

extension Date {
    
    typealias DateInterval = (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?)
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    static func -(recent: Date, previous: Date) -> DateInterval {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    static func generateDate(rawDate:String) -> String {
        guard rawDate != "",
              let sub = rawDate.split(separator: ".").first else {return ""}
        let modified = String(sub)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-d'T'HH:mm:ss"
        let inputDate = df.date(from: modified) ?? Date()
        let interval: DateInterval = Date() - inputDate
        if let month = interval.month, month > 0 {
            df.dateFormat = "yyyy.MM.dd HH:mm"
            return df.string(from: inputDate)
        } else if let day = interval.day, day > 0 {
            return "\(day)일 전"
        } else if let hour = interval.hour, hour > 0 {
            return "\(hour)시간 전"
        } else if let minute = interval.minute, minute > 0 {
            return "\(minute)분 전"
        } else {
            return "방금 전"
        }
    }
}
