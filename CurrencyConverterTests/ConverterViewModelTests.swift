//
//  ConverterViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by rabin on 22/07/2022.
//

import XCTest
@testable import CurrencyConverter

class ConverterViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidateAmountAndCurrency() throws {
        let sut = ConverterViewModel()
        
        sut.newAmount.value = 0
        sut.selectedCurrencyInformation.value = (currency: Currency.Object(rate: 0, code: "usd", name: "US Dollars"), index: 0)
        XCTAssertEqual(sut.validateAmountAndCurrency(), .amountNotSelected)
        
        sut.newAmount.value = 1.1
        sut.selectedCurrencyInformation.value = nil
        XCTAssertEqual(sut.validateAmountAndCurrency(), .currencyNotSelected)
        
        sut.newAmount.value = 0
        sut.selectedCurrencyInformation.value = nil
        XCTAssertEqual(sut.validateAmountAndCurrency(), .amountNotSelected)
        
        sut.newAmount.value = -1
        sut.selectedCurrencyInformation.value = (currency: Currency.Object(rate: 0, code: "usd", name: "US Dollars"), index: 0)
        XCTAssertEqual(sut.validateAmountAndCurrency(), .invalidAmount)
        
        sut.newAmount.value = 1
        sut.selectedCurrencyInformation.value = (currency: Currency.Object(rate: 0, code: "usd", name: "US Dollars"), index: 0)
        XCTAssertEqual(sut.validateAmountAndCurrency(), nil)
    }
    
    func testCanConvert() throws {
        let sut = ConverterViewModel()
        
        sut.newAmount.value = 0
        sut.selectedCurrencyInformation.value = (currency: Currency.Object(rate: 0, code: "usd", name: "US Dollars"), index: 0)
        XCTAssertEqual(sut.canConvert(), false)
        
        sut.newAmount.value = 1.1
        sut.selectedCurrencyInformation.value = nil
        XCTAssertEqual(sut.canConvert(), false)
        
        sut.newAmount.value = 0
        sut.selectedCurrencyInformation.value = nil
        XCTAssertEqual(sut.canConvert(), false)
        
        sut.newAmount.value = -1
        sut.selectedCurrencyInformation.value = (currency: Currency.Object(rate: 0, code: "usd", name: "US Dollars"), index: 0)
        XCTAssertEqual(sut.canConvert(), false)
        
        sut.newAmount.value = 1
        sut.selectedCurrencyInformation.value = (currency: Currency.Object(rate: 0, code: "usd", name: "US Dollars"), index: 0)
        XCTAssertEqual(sut.canConvert(), true)
    }
    
    func testGetConversionAmount() {
        let sut = ConverterViewModel()
        
        sut.newAmount.value = 0
        sut.selectedCurrencyInformation.value = (currency: Currency.Object(rate: 0, code: "usd", name: "US Dollars"), index: 0)
        XCTAssertEqual(sut.getConvertedAmount(for: 100), 0)
        
        sut.newAmount.value = 2
        sut.selectedCurrencyInformation.value = (currency: Currency.Object(rate: 100, code: "usd", name: "US Dollars"), index: 0)
        XCTAssertEqual(sut.getConvertedAmount(for: 100), 2)
        
        sut.newAmount.value = 100
        sut.selectedCurrencyInformation.value = (currency: Currency.Object(rate: 100, code: "usd", name: "US Dollars"), index: 0)
        XCTAssertEqual(sut.getConvertedAmount(for: 0), 0)
        
        sut.newAmount.value = 1.1
        sut.selectedCurrencyInformation.value = (currency: Currency.Object(rate: 100.1, code: "usd", name: "US Dollars"), index: 0)
        XCTAssertEqual(sut.getConvertedAmount(for: 5), 0.05494506)
        
        sut.newAmount.value = 0
        sut.selectedCurrencyInformation.value = (currency: Currency.Object(rate: 0, code: "usd", name: "US Dollars"), index: 0)
        XCTAssertEqual(sut.getConvertedAmount(for: 100), 0)
    }
    
    func testFetchedResultsControllerFetchedObjectsCount() {
        let dataBase = MockDatabase()
        dataBase.initalizaDB()
        
        let context = dataBase.bgContext
        let sut = ConverterViewModel(databaseContext: context)
        
        dataBase.addObjectsInDB(context: context)
        try? sut.currencyFetchedResultsController.performFetch()
        XCTAssertEqual(sut.currencyFetchedResultsController.fetchedObjects?.count, 10)
        
        dataBase.addObjectsInDB(context: context)
        try? sut.currencyFetchedResultsController.performFetch()
        XCTAssertEqual(sut.currencyFetchedResultsController.fetchedObjects?.count, 20)
        
    }

}
