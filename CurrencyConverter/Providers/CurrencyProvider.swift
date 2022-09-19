//
//  ConversionRateFetcher.swift
//  CurrencyConverter
//
//  Created by rabin on 20/07/2022.
//

import Foundation
import Combine

typealias Currencies = [String: String]
typealias CurrenyCoreDataRepository = CoreDataRepository<Currency.Object>

enum CurrencyError: LocalizedError {
    case failedToFetchCurrencies
    case failedToFetchConversionRates
    case currenciesEmpty
    
    var errorDescription: String? {
        switch self {
        case .failedToFetchCurrencies:
            return "Failed to fetch the currencies."
        case .failedToFetchConversionRates:
            return "Failed to fetch the conversion rates."
        case .currenciesEmpty:
            return "Currency list is empty"
        }
    }
}

struct CurrenciesToCurrencyObjectAdapter: Adapter{
    typealias Output = [Currency.Object]
    typealias Input = Currencies
    
    func adapt(_ input: Input) -> Output {
        input.map({ Currency.Object(rate: 0, code: $0.key, name: $0.value) })
    }
    
}

final class CurrencyApiRepository: ApiRepository<Currency.Object> {
    
    let url = Environment.getUrl(for: .currencies)
    
    override func fetch() {
        cancellable = perfomrRequest(url: url, adapter: CurrenciesToCurrencyObjectAdapter())
            .sink(receiveCompletion: { self.handleCompletion(result: $0) },
                  receiveValue: { result in
                self.result.send(.success(result))
            })
    }
    
    private func currenciesToCurrencyObjectMapper(_ currencies: Currencies) -> [Currency.Object] {
        currencies.map({ Currency.Object(rate: 0, code: $0.key, name: $0.value) })
    }
    
}


class CurrenciesDataProvider: BaseDataProvider<Currency.Object> {
    
    private let dbRepository: CoreDataRepository<ResultType>
    
    private let networkStatusProvider: NetworkStatusProvider

    private let currencyApiRepository: CurrencyApiRepository
    
    private let conversionRateApiRepository: ConversionRateApiRepository
    
    private let url = Environment.getUrl(for: .currencies)
    
    private var conversionRateCancellable: AnyCancellable?
    private var currencyListCancellable: AnyCancellable?
    
    init (dbRepository: CoreDataRepository<ResultType>, networkStatusProvider: NetworkStatusProvider, conversionRateApiRepository: ConversionRateApiRepository, currencyApiRepository: CurrencyApiRepository) {
        self.dbRepository = dbRepository
        self.networkStatusProvider = networkStatusProvider
        self.conversionRateApiRepository = conversionRateApiRepository
        self.currencyApiRepository = currencyApiRepository
        super.init()
    }
    
    func observeEvents() {
        conversionRateCancellable = conversionRateApiRepository.result.sink { result in
            switch result {
            case .success(let data):
                guard let currencies = self.dbRepository.fetch(with: nil), !currencies.isEmpty else {
                    self.result.send(.failure(CurrencyError.currenciesEmpty))
                    return
                }
                var updatedCurrencies = [Currency.Object]()
                for currency in currencies {
                    updatedCurrencies.append(Currency.Object(rate: data.first(where: { $0.code == currency.code })?.rate ?? 0.0, code: currency.code, name: currency.name))
                }
                self.updateTheFetchDate()
                self.dbRepository.clearRepository()
                self.dbRepository.batchWrite(with: updatedCurrencies)
                self.isFetching = false
                self.result.send(.success(updatedCurrencies))
            case .failure(let error):
                self.result.send(.failure(error))
            }
        }
        
        currencyListCancellable = currencyApiRepository.result.sink { result in
            switch result {
            case .success(let data):
                guard !data.isEmpty else {
                    self.result.send(.failure(CurrencyError.currenciesEmpty))
                    return }
                self.dbRepository.clearRepository()
                self.dbRepository.batchWrite(with: data)
                self.fetchConversionRates()
            case .failure(let error):
                self.result.send(.failure(error))
            }
        }
    }
    
    override func fetch() {
        if networkStatusProvider.isOn && shouldFetchNewData() {
            fetchFromApi()
        } else {
            fetchFromDB()
        }
    }
    
    private func fetchFromDB() {
        guard let objects = self.dbRepository.fetch(with: nil), !objects.isEmpty else {
            fetchFromApi()
            return
        }
        result.send(.success(objects))
    }
    
    private func fetchFromApi() {
        guard !isFetching else { return }
        isFetching.toggle()
        currencyApiRepository.fetch()
    }
    
    func fetchConversionRates() {
        conversionRateApiRepository.fetch()
    }
    
}
