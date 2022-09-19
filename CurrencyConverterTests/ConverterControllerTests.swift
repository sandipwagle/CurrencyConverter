//
//  ConverterControllerTests.swift
//  CurrencyConverterTests
//
//  Created by rabin on 22/07/2022.
//

import XCTest
@testable import CurrencyConverter

class ConverterControllerTests: XCTestCase {

    func testControllerIsShowingSpinner() throws {
        
        let sut = ConverterController(baseView: ConverterView(), baseViewModel: ConverterViewModel())
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.screenView.indicate, true)
    }
    
    func testControllerIsNotShowingSpinner() throws {
        
        let dataBase = MockDatabase()
        dataBase.initalizaDB()
        
        let currencyProvider = MockCurrencyProvider(dbRepository: CurrenyCoreDataRepository(), networkStatusProvider: NetworkStatusProvider.shared, conversionRateApiRepository: ConversionRateApiRepository(), currencyApiRepository: CurrencyApiRepository())

        let context = dataBase.bgContext
        let viewModel = ConverterViewModel(databaseContext: context, currencyFetcher: currencyProvider)
        
        dataBase.addObjectsInDB(context: context)
        
        let sut = ConverterController(baseView: ConverterView(), baseViewModel: viewModel)
        sut.loadViewIfNeeded()
        let expectation = self.expectation(description: "hide spinner")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !sut.screenView.indicate {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testControllerIsShowingErrorCell() throws {
        
        let dataBase = MockDatabase()
        dataBase.initalizaDB()
        
        let currencyProvider = MockCurrencyProvider(dbRepository: CurrenyCoreDataRepository(), networkStatusProvider: NetworkStatusProvider.shared, conversionRateApiRepository: ConversionRateApiRepository(), currencyApiRepository: CurrencyApiRepository())

        let context = dataBase.bgContext
        let viewModel = ConverterViewModel(databaseContext: context, currencyFetcher: currencyProvider)

        dataBase.addObjectsInDB(context: context)
        let view =  ConverterView()
        
        let sut = ConverterController(baseView: view, baseViewModel: viewModel)
        sut.loadViewIfNeeded()
        
        let expectation = self.expectation(description: "collection view count")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let collectionView = sut.screenView.conversionCollectionView
            let numberOfCell = sut.screenView.conversionCollectionView.numberOfItems(inSection: 0)
            let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as! CurrencyErrorCell
            if numberOfCell == 1, cell.errorLabel.text == ConversionError.amountNotSelected.localizedDescription {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testControllerCorrectCellsAreVisible() throws {
        
        let dataBase = MockDatabase()
        dataBase.initalizaDB()
        
        let currencyProvider = MockCurrencyProvider(dbRepository: CurrenyCoreDataRepository(), networkStatusProvider: NetworkStatusProvider.shared, conversionRateApiRepository: ConversionRateApiRepository(), currencyApiRepository: CurrencyApiRepository())

        let context = dataBase.bgContext
        let viewModel = ConverterViewModel(databaseContext: context, currencyFetcher: currencyProvider)
        
        viewModel.selectedCurrencyInformation.value = (currency: Currency.Object(rate: 0, code: "usd", name: "US Dollars"), index: 0)
        viewModel.newAmount.value = 100

        dataBase.addObjectsInDB(context: context)
        
        let view =  ConverterView()
        
        let sut = ConverterController(baseView: view, baseViewModel: viewModel)
        sut.loadViewIfNeeded()
        
        let expectation = self.expectation(description: "collection view count")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let collectionView = sut.screenView.conversionCollectionView
            let numberOfCell = sut.screenView.conversionCollectionView.numberOfItems(inSection: 0)
            let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as! ConversionResultCell
            if numberOfCell == 10, cell.currencyName.text == "US Dollars\n(usd)" {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

}
