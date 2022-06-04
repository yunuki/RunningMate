//
//  User.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import Foundation

struct User: Codable {
    let id: Int
    let nickname: String
    let group: Group?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, nickname, group
        case createdAt = "created_at"
    }
}
