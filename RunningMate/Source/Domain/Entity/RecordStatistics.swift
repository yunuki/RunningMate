//
//  RecordStatistics.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/31.
//

import Foundation

struct RecordStatistics: Codable {
    let userId: Int
    let year: Int?
    let month: Int?
    let distance: Double
    let duration: Int
    let pace: Double
    let kcal: Double
    
    enum CodingKeys: String, CodingKey {
        case userId = "account_id"
        case year, month, distance, duration, pace, kcal
    }
}
