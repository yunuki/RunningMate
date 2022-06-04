//
//  RecordNetwork.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/29.
//

import Foundation
import RxSwift

final class RecordNetwork {
    let network: Network<Record>
    
    init(network: Network<Record>) {
        self.network = network
    }
    
    func getRecord(recordId: Int) -> Observable<Record> {
        return network.getItem("record", itemId: "\(recordId)")
    }
    
    func getRecords(queryParams: [String:Any]?) -> Observable<[Record]> {
        return network.getItems("record/list", queryParams: queryParams)
    }
    
    func postRecord(parameters: [String:Any]) -> Observable<Record> {
        return network.postItem("record", parameters: parameters)
    }
}
