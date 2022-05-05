//
//  BaseViewModel.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
