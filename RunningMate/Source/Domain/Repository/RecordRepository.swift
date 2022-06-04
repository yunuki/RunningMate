//
//  RecordRepository.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/29.
//

import Foundation
import RxSwift

protocol RecordRepository {
    func record(recordId: Int) -> Observable<Record>
    func records(queryParams: [String:Any]?) -> Observable<[Record]>
    func create(parameters: [String:Any]) -> Observable<Record>
}

final class DefaultRecordRepository: RecordRepository {
    
    private let recordNetwork: RecordNetwork
    
    init(recordNetwork: RecordNetwork) {
        self.recordNetwork = recordNetwork
    }
    
    func record(recordId: Int) -> Observable<Record> {
        return recordNetwork.getRecord(recordId: recordId)
    }
    
    func records(queryParams: [String : Any]?) -> Observable<[Record]> {
        return recordNetwork.getRecords(queryParams: queryParams)
    }
    
    func create(parameters: [String : Any]) -> Observable<Record> {
        return recordNetwork.postRecord(parameters: parameters)
    }
}

protocol RecordStatisticsRepository {
    func recordStatistics(userId: Int, year: Int?, month: Int?, isAverage: Bool) -> Observable<RecordStatistics>
}

final class DefaultRecordStatisticsRepository: RecordStatisticsRepository {
    
    private let network: RecordStatisticsNetwork
    
    init(network: RecordStatisticsNetwork) {
        self.network = network
    }
    
    func recordStatistics(userId: Int, year: Int?, month: Int?, isAverage: Bool) -> Observable<RecordStatistics> {
        return network.getRecordStatistics(userId: userId, year: year, month: month, isAverage: isAverage)
    }
}
