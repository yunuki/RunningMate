//
//  Auth.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/11.
//

import Foundation

struct Auth: Codable {
    let user: User
    let token: String
    let isNew: Bool
    
    enum CodingKeys: String, CodingKey {
        case user = "account"
        case token = "refresh_token"
        case isNew = "is_new"
    }
}
