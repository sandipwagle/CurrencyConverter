//
//  BaseProvider.swift
//  CurrencyConverter
//
//  Created by rabin on 20/07/2022.
//

import Foundation
import Combine

protocol DataProvider {
    associatedtype ResultType
    
    var result: PassthroughSubject<Result<[ResultType], Error>,Never> { get }
    func fetch()
}


class BaseDataProvider<T>: DataProvider {
    
    typealias ResultType = T

    var result = PassthroughSubject<Result<[ResultType], Error>, Never>()
    var cancellable: AnyCancellable?
    
    let urlSession: URLSession
    
    var isFetching = false
    
    @UserDefault(name: Constant.UserDefaultKeys.lastFetchDate, defaultValue: Date())
    private var lastFetchDate: Date
    
    // fetch new data if the data is stale (more than 30 mins)
    func shouldFetchNewData() -> Bool {
        let currentDate = Date()
        let timeLapsedInSeconds = currentDate.timeIntervalSince1970 - lastFetchDate.timeIntervalSince1970
        return timeLapsedInSeconds > 1800
    }
    
    func updateTheFetchDate() {
        lastFetchDate = Date()
    }
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetch() {
    }
    
}
