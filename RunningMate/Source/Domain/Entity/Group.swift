//
//  Group.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/31.
//

import Foundation

struct Group: Codable {
    
    enum GroupType: String, Codable {
        case DAY_INSIDE_FAST
        case DAY_INSIDE_SLOW
        case DAY_OUTSIDE_FAST
        case DAY_OUTSIDE_SLOW
        case NIGHT_INSIDE_FAST
        case NIGHT_INSIDE_SLOW
        case NIGHT_OUTSIDE_FAST
        case NIGHT_OUTSIDE_SLOW
    }
    let id: Int
    let character: String
    let type: GroupType
    
    enum CodingKeys: String, CodingKey {
        case id, character, type
    }
}
