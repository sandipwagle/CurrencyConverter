//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by rabin on 19/07/2022.
//

import XCTest
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCurrencyConversion() throws {
        let sut = CurrencyConverter()
        XCTAssertEqual(sut.convert(1, fromConversionRate: 1, toConversionRate: 1.5), 1.5)
        XCTAssertEqual(sut.convert(2, fromConversionRate: 1, toConversionRate: 1.5), 3)
        XCTAssertEqual(sut.convert(2, fromConversionRate: 3, toConversionRate: 1.5), 1)
    }

}
