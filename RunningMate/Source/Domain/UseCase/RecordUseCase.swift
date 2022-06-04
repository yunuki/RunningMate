//
//  RecordUseCase.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/29.
//

import Foundation
import RxSwift

protocol RecordUseCase {
    func fetchRecord(recordId: Int) -> Observable<Record>
    func fetchRecords(queryParams: [String:Any]?) -> Observable<[Record]>
    func createRecord(parameters: [String:Any]) -> Observable<Record>
}

final class DefaultRecordUseCase: RecordUseCase {
    private let repository: RecordRepository
    
    init(repository: RecordRepository) {
        self.repository = repository
    }
    
    func fetchRecord(recordId: Int) -> Observable<Record> {
        return repository.record(recordId: recordId)
    }
    
    func fetchRecords(queryParams: [String : Any]?) -> Observable<[Record]> {
        return repository.records(queryParams: queryParams)
    }
    
    func createRecord(parameters: [String : Any]) -> Observable<Record> {
        return repository.create(parameters: parameters)
    }
}

protocol RecordStatisticsUseCase {
    func fetchRecordStatistics(userId: Int, year: Int?, month: Int?, isAverage: Bool) -> Observable<RecordStatistics>
}

final class DefaultRecordStatisticsUseCase: RecordStatisticsUseCase {
    
    private let repository: RecordStatisticsRepository
    
    init(repository: RecordStatisticsRepository) {
        self.repository = repository
    }
    
    func fetchRecordStatistics(userId: Int, year: Int?, month: Int?, isAverage: Bool) -> Observable<RecordStatistics> {
        return repository.recordStatistics(userId: userId, year: year, month: month, isAverage: isAverage)
    }
}
