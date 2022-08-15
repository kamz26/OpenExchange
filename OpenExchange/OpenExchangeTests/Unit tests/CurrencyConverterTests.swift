//
//  CurrencyConverterTests.swift
//  OpenExchangeTests
//
//  Created by Abhishek Kashyap on 15/08/22.
//

import XCTest
@testable import OpenExchange

class CurrencyConverterTests: XCTestCase {
  
  private var currencyConverter:CurrencyConverterProtocol!

    override func setUpWithError() throws {
      try super.setUpWithError()
      self.currencyConverter = CurrencyConverter()
    }

    override func tearDownWithError() throws {
      try super.tearDownWithError()
      self.currencyConverter = nil
    }
  
  func test_currency_converter(){
    currencyConverter.baseCurrency = "INR"
    currencyConverter.globalBaseCurrency = "USD"
    XCTAssertEqual(currencyConverter.convert(amount: 10, currencyValue: 3.6731), 36.73)
  }
  
  func test_currency_converter_not_equal(){
    currencyConverter.baseCurrency = "INR"
    currencyConverter.globalBaseCurrency = "USD"
    XCTAssertNotEqual(currencyConverter.convert(amount: 10, currencyValue: 3.6731), 36, "")
  }
  
  func test_currency_converter_with_base_globalBase_same(){
    currencyConverter.baseCurrency = "USD"
    currencyConverter.globalBaseCurrency = "USD"
    XCTAssertNotEqual(currencyConverter.convert(amount: 10, currencyValue: 3.6731), 36, "")
  }
  
  func test_currency_converter_with_base_globalBase_same_success(){
    currencyConverter.baseCurrency = "USD"
    currencyConverter.globalBaseCurrency = "USD"
    XCTAssertEqual(currencyConverter.convert(amount: 10, currencyValue: 3.6731), 36.73, "")
  }
  
  func test_currency_converter_with_base_globalBase_same_failure(){
    currencyConverter.baseCurrency = "USD"
    currencyConverter.globalBaseCurrency = "USD"
    XCTAssertNotEqual(currencyConverter.convert(amount: 10, currencyValue: 3.6731), 36, "")
  }
}
