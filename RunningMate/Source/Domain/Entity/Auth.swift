//
//  Auth.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/11.
//

import Foundation

struct Auth: Codable {
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case user
    }
}
