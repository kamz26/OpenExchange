//
//  CurrencyListViewModelTest.swift
//  OpenExchangeTests
//
//  Created by Abhishek Kashyap on 15/08/22.
//

import XCTest
@testable import OpenExchange

class CurrencyListViewModelTest: XCTestCase {
  
  private var currencyListVM:CurrencyListViewModel!

    override func setUpWithError() throws {
      try super.setUpWithError()
      currencyListVM = CurrencyListViewModel( converter: CurrencyConverter())
    }

    override func tearDownWithError() throws {
      try super.tearDownWithError()
      currencyListVM = nil
    }
  
  func test_baseFetch_non_Empty(){
    let expection = self.expectation(description: "test fetch")
    currencyListVM.getCurrenciesData()
    DispatchQueue.main.asyncAfter(deadline: .now() + OpenExchangeTestConstant.test_waitTime) {
      expection.fulfill()
      XCTAssertGreaterThanOrEqual(self.currencyListVM.currencyConverter.baseCurrency.count, 0)
    }
    wait(for: [expection], timeout: OpenExchangeTestConstant.test_waitTime)
  }
    
  func test_baseFetch(){
    let expection = self.expectation(description: "test fetch")
    
    currencyListVM.getCurrenciesData()
    DispatchQueue.main.asyncAfter(deadline: .now() + OpenExchangeTestConstant.test_waitTime) {
      expection.fulfill()
      XCTAssertEqual(self.currencyListVM.currencyConverter.baseCurrency, "USD")
    }
    wait(for: [expection], timeout: OpenExchangeTestConstant.test_waitTime)
  }
  
  func test_db_save(){
    let expection = self.expectation(description: "db save test")
    
    currencyListVM.getCurrenciesData()
    DispatchQueue.main.asyncAfter(deadline: .now() + OpenExchangeTestConstant.test_waitTime) {
      expection.fulfill()
      XCTAssertEqual(self.currencyListVM.dbManager.getData()?.count, 1)
    }
    wait(for: [expection], timeout: OpenExchangeTestConstant.test_waitTime)
  }
  
  func test_currency_Rate_not_nil(){
    let expection = self.expectation(description: "test rate not nil")
    
    currencyListVM.getCurrenciesData()
    DispatchQueue.main.asyncAfter(deadline: .now() + OpenExchangeTestConstant.test_waitTime) {
      expection.fulfill()
      
      XCTAssertNotNil(self.currencyListVM.currencyModel)
    }
    wait(for: [expection], timeout: OpenExchangeTestConstant.test_waitTime)
  }
  
  func test_currencyCount(){
    let expection = self.expectation(description: "fetch Currency count")
    
    currencyListVM.getCurrenciesData()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + OpenExchangeTestConstant.test_waitTime) {
      expection.fulfill()
      XCTAssertGreaterThan(self.currencyListVM.currenciesCount, 0)
    }
    wait(for: [expection], timeout: OpenExchangeTestConstant.test_waitTime)
  }
  
  func test_calculate_amount_conversion(){
    let expection = self.expectation(description: "calculate amount conversion")
    
    currencyListVM.getCurrenciesData()
    currencyListVM.currentEnteredAmount = 10.0
    DispatchQueue.main.asyncAfter(deadline: .now() + OpenExchangeTestConstant.test_waitTime) {
      expection.fulfill()
      XCTAssertGreaterThan(self.currencyListVM.getAmountForCurrency(curreny: "INR"), 0)
    }
    wait(for: [expection], timeout: OpenExchangeTestConstant.test_waitTime)
  }
}
