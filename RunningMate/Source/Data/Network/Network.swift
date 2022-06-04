//
//  Network.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import Foundation
import RxSwift
import RxAlamofire

final class Network<T: Decodable> {
    
    private let endPoint: String
    private let scheduler: ConcurrentDispatchQueueScheduler
    
    init(_ endPoint: String) {
        self.endPoint = endPoint
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
    }
    
    func getItems(_ path: String, queryParams: [String : Any]? = nil) -> Observable<[T]> {
        let absolutePath = "\(endPoint)/\(path)"
        
        var components = URLComponents(string: absolutePath)
        components?.queryItems = queryParams?.map { k, v in
            return URLQueryItem(name: k, value: "\(v)")
        }
        
        return RxAlamofire
            .data(.get, components?.url ?? absolutePath)
            .debug()
            .observe(on: scheduler)
            .map({ data -> [T] in
                return try JSONDecoder().decode([T].self, from: data)
            })
    }

    func getItem(_ path: String, itemId: String, queryParams: [String : Any]? = nil) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)/\(itemId)"
        
        var components = URLComponents(string: absolutePath)
        components?.queryItems = queryParams?.map { k, v in
            return URLQueryItem(name: k, value: "\(v)")
        }
        
        return RxAlamofire
            .data(.get, components?.url ?? absolutePath)
            .debug()
            .observe(on: scheduler)
            .map({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            })
    }

    func postItem(_ path: String, parameters: [String: Any]) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)"
        return RxAlamofire
            .request(.post, absolutePath, parameters: parameters)
            .debug()
            .observe(on: scheduler)
            .data()
            .map({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            })
    }

    func updateItem(_ path: String, itemId: String, parameters: [String: Any]) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)/\(itemId)"
        return RxAlamofire
            .request(.put, absolutePath, parameters: parameters)
            .debug()
            .observe(on: scheduler)
            .data()
            .map({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            })
    }

    func deleteItem(_ path: String, itemId: String) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)/\(itemId)"
        return RxAlamofire
            .request(.delete, absolutePath)
            .debug()
            .observe(on: scheduler)
            .data()
            .map({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            })
    }
}
