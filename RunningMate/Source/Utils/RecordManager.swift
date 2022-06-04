//
//  RecordManager.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import UIKit
import CoreMotion
import HealthKit

protocol RecordManagerDelegate: AnyObject {
    func didDistanceChanged(distance: Double)
    func didKcalChanged(kcal: Double)
    func didPaceChanged(pace: Double)
    func didTimeChanged(time: TimeInterval)
}

final class RecordManager: CMPedometer {
    static let shared = RecordManager()
    private var timer: DispatchSourceTimer?
    private var time = TimeInterval()
    private var startDate: Date?
    private let healthStore = HKHealthStore()
    weak var delegate: RecordManagerDelegate?
    
    override init() {
        super.init()
        let types = Set([HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!])
        healthStore.requestAuthorization(toShare: types, read: types) { success, error in
            
        }
    }

    func start() {

        if self.timer == nil {
            self.startDate = Date()
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            self.timer?.schedule(deadline: .now(), repeating: 1.0)
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let `self` = self else {return}
                self.time += 1
                self.delegate?.didTimeChanged(time: self.time)
            })
            self.timer?.resume()
        }
        
        self.startUpdates(from: startDate ?? Date()) { [weak self] data, error in
            self?.handlePedometer(data)
        }
    }
    
    func pause() {
        self.timer?.suspend()
        self.stopUpdates()
        self.getKcal()
    }
    
    func resume() {
        self.timer?.resume()
        start()
    }
    
    func end() {
        self.timer?.cancel()
        self.timer = nil
        self.time = TimeInterval()
        self.startDate = nil
        self.delegate = nil
        self.stopUpdates()
    }
    
    func handlePedometer(_ data: CMPedometerData?) {
        guard let data = data else {return}
        
        let distance = (data.distance?.doubleValue ?? 0.0) / 1000 //km
        let pace = (data.averageActivePace?.doubleValue ?? 0.0) * 1000 / 60 //minutes per kilometer
        
        DispatchQueue.main.async {
            self.delegate?.didDistanceChanged(distance: distance)
            self.delegate?.didPaceChanged(pace: pace)

        }
    }
    
    func getKcal() {
        guard HKHealthStore.isHealthDataAvailable() else {return}
        let quantityType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        let calendar = Calendar.current
        var anchorComponents: DateComponents? = calendar.dateComponents([.minute, .hour, .day, .month, .year], from: Date())
        anchorComponents?.second = 0
        var interval = DateComponents()
        interval.minute = 1
        let anchorDate = calendar.date(from: anchorComponents!)
        let query = HKStatisticsCollectionQuery(quantityType: quantityType!, quantitySamplePredicate: nil, anchorDate: anchorDate!, intervalComponents: interval)
        query.initialResultsHandler = {[weak self] (query: HKStatisticsCollectionQuery, results: HKStatisticsCollection?, error: Error?) -> Void in
            guard let `self` = self,
                  let results = results else {return}
            results.enumerateStatistics(from: self.startDate!, to: Date()) { result, stop in
                guard let quantity = result.sumQuantity() else {return}
                let kcal = quantity.doubleValue(for: HKUnit.kilocalorie())
                DispatchQueue.main.async {
                    self.delegate?.didKcalChanged(kcal: kcal)
                }
            }
        }
        self.healthStore.execute(query)
    }
}
