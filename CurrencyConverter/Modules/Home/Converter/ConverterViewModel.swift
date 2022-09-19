//
//  ConverterViewModel.swift
//  CurrencyConverter
//
//  Created by rabin on 19/07/2022.
//

import Foundation
import CoreData
import Combine

enum ConversionError: LocalizedError {
    case amountNotSelected, currencyNotSelected, invalidAmount
    
    var errorDescription: String? {
        switch self {
        case .amountNotSelected:
            return "Please select an amount."
        case .currencyNotSelected:
            return "Please select a currency"
        case .invalidAmount:
            return "Please select a valid amount."
        }
    }
}

typealias CurrencyInformation = (currency: Currency.Object, index: Int)

protocol ConverterViewModelProtocol: BaseViewModelProtocol {
    var currencyResult: PassthroughSubject<Result<[Currency.Object], Error>,Never> { get }
    var selectedCurrencyInformation: CurrentValueSubject<CurrencyInformation?,Never> { get }
    var newAmount: CurrentValueSubject<Float,Never> { get }
    var currencies: [Currency] { get }
    
    func addFetchControllerDelegate(_ delegate: NSFetchedResultsControllerDelegate) throws
    func setup()
    func validateAmountAndCurrency() -> ConversionError?
    func canConvert() -> Bool
    func getConvertedAmount(for currencyRate: Float) -> Float
}

final class ConverterViewModel: BaseViewModel, ConverterViewModelProtocol {

    private let nonZeroConversionRatePredicate = NSPredicate(format: "%K != %@", #keyPath(Currency.rate), NSNumber(0))
    private let nonNullCodePredicate = NSPredicate(format: "%K != NULL", #keyPath(Currency.code))
    private let currencyConverter = CurrencyConverter()
    private let databaseContext: NSManagedObjectContext
    private let currencyFetcher: CurrenciesDataProvider
    private lazy var currencyFetchedResultsController: NSFetchedResultsController<Currency> = {
        let request = NSFetchRequest<Currency>(entityName: Currency.entityName)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [nonNullCodePredicate, nonZeroConversionRatePredicate])
        let nameSort = NSSortDescriptor(key: #keyPath(Currency.name), ascending: true)
        request.sortDescriptors = [nameSort]
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: databaseContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    var currencies: [Currency] { currencyFetchedResultsController.fetchedObjects ?? [] }
    let newAmount = CurrentValueSubject<Float,Never>(0)
    let selectedCurrencyInformation = CurrentValueSubject<CurrencyInformation?,Never>(nil)
    var  currencyResult: PassthroughSubject<Result<[Currency.Object], Error>, Never> { currencyFetcher.result }
    
    
    init(databaseContext: NSManagedObjectContext = Database.default.bgContext, currencyFetcher: CurrenciesDataProvider = CurrenciesDataProvider(dbRepository: CurrenyCoreDataRepository(), networkStatusProvider: NetworkStatusProvider.shared, conversionRateApiRepository: ConversionRateApiRepository(), currencyApiRepository: CurrencyApiRepository())) {
        self.databaseContext = databaseContext
        self.currencyFetcher = currencyFetcher
    }
    
    func setup() {
        currencyFetcher.observeEvents()
        currencyFetcher.fetch()
    }
    
    func addFetchControllerDelegate(_ delegate: NSFetchedResultsControllerDelegate) throws {
        currencyFetchedResultsController.delegate = delegate
        try currencyFetchedResultsController.performFetch()
    }
    
    @discardableResult
    func validateAmountAndCurrency() -> ConversionError? {
        guard newAmount.value != -1 else { return .invalidAmount }
        guard newAmount.value > 0 else { return .amountNotSelected }
        guard selectedCurrencyInformation.value != nil else { return .currencyNotSelected }
        return nil
    }
    
    func canConvert() -> Bool {
        validateAmountAndCurrency() == nil
    }
    
    func getConvertedAmount(for currencyRate: Float) -> Float {
        guard let selectedCurrency = selectedCurrencyInformation.value?.currency else { return 0 }
        return currencyConverter.convert(newAmount.value, fromConversionRate: selectedCurrency.rate, toConversionRate: currencyRate)
    }
    
}
