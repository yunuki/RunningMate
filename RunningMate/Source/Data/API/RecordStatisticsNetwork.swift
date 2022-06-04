//
//  RecordStatisticsNetwork.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/31.
//

import Foundation
import RxSwift

class RecordStatisticsNetwork {
    let network: Network<RecordStatistics>
    
    init(network: Network<RecordStatistics>) {
        self.network = network
    }
    
    func getRecordStatistics(userId: Int, year: Int?, month: Int?, isAverage: Bool) -> Observable<RecordStatistics> {
        var queryParams: [String:Any]?
        queryParams = ["average": isAverage]
        if let year = year,
           let month = month {
            queryParams?["year"] = year
            queryParams?["month"] = month
        }
        return network.getItem("record/statistics", itemId: "\(userId)", queryParams: queryParams)
    }
}
