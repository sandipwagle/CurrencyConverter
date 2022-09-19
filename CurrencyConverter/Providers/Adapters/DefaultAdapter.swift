//
//  DefaultAdapter.swift
//  CurrencyConverter
//
//  Created by ebpearls on 29/08/2022.
//

import Foundation

protocol Adapter {
    associatedtype Input: Decodable
    associatedtype Output
    
    func adapt(_ input: Input) -> Output
}

struct DefaultAdapter<T: Decodable>: Adapter {
    typealias Input = T
    typealias Output = T
    
    func adapt(_ input: Input) -> Output {
        return input
    }
}
