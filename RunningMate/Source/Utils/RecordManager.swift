//
//  RecordManager.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import Foundation
import CoreMotion

final class RecordManager: CMPedometer {
    static let shared = RecordManager()
    
    override init() {
        super.init()
        
    }

}
