//
//  RecordManager.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import UIKit
import CoreMotion

protocol RecordManagerDelegate: AnyObject {
    func didDistanceChanged(distance: CGFloat)
    func didPaceChanged(pace: CGFloat)
    func didTimeChanged(time: TimeInterval)
}

final class RecordManager: CMPedometer {
    static let shared = RecordManager()
    private var timer: Timer?
    private var startDate: Date?
    weak var delegate: RecordManagerDelegate?
    
    override init() {
        super.init()
    }

    func start() {

        if self.timer == nil {
            self.startDate = Date()
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
                self?.delegate?.didTimeChanged(time: Date() - (self?.startDate ?? Date()))
            })
            
        }
        
        self.startUpdates(from: Date()) { [weak self] data, error in
            guard let data = data else {return}
            
            let distance = data.distance?.doubleValue ?? 0.0
            let pace = data.currentPace?.doubleValue ?? 0.0
            
            self?.delegate?.didDistanceChanged(distance: distance)
            self?.delegate?.didPaceChanged(pace: pace)
            
        }
    }
    
    func end() {
        self.timer?.invalidate()
        self.timer = nil
        self.startDate = nil
        self.delegate = nil
        self.stopUpdates()
    }
}
