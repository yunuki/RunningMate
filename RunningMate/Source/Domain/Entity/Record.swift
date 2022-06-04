//
//  Record.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/29.
//

import Foundation

enum Place: String, Codable {
    case inside, outside
}

enum Timezone: String, Codable {
    case day, night
}

struct Record: Codable {
    
    let id: Int
    let user: User
    let distance: Double
    let kcal: Double
    let pace: Double
    let duration: Int
    let place: Place
    let timezone: Timezone
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, distance, kcal, pace, duration, place, timezone
        case user = "account"
        case createdAt = "created_at"
    }
}
