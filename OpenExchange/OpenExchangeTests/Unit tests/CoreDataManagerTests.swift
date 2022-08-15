//
//  CoreDataManagerTests.swift
//  OpenExchangeTests
//
//  Created by Abhishek Kashyap on 15/08/22.
//

import XCTest
@testable import OpenExchange




class CoreDataManagerTests: XCTestCase {
  
  var coreDataManager:CoreDataManager!

    override func setUpWithError() throws {
      try super.setUpWithError()
      self.coreDataManager = CoreDataManager()
    }

    override func tearDownWithError() throws {
      try super.tearDownWithError()
      self.coreDataManager = nil
    }
  
  func test_save_data(){
    self.coreDataManager.deleteData()
    self.coreDataManager.saveData(data: OpenExchangeTestConstant.getCurrencyListModel())
    XCTAssertEqual(self.coreDataManager.getData()?.count, 1)
  }
  
  func test_save_failure(){
    self.coreDataManager.saveData(data: OpenExchangeTestConstant.getCurrencyListVM())
    XCTAssertEqual(self.coreDataManager.getData()?.count, 1)
  }
  
  func test_syncing(){
    self.coreDataManager.deleteData()
    self.coreDataManager.saveData(data: OpenExchangeTestConstant.getCurrencyListModel())
    XCTAssertFalse(self.coreDataManager.isSyncRequired())
  }
}


fileprivate extension OpenExchangeTestConstant{
  static func getCurrencyListModel() -> CurrencyListModel{
    return CurrencyListModel(disclaimer: "Usage subject to terms: https://openexchangerates.org/terms",
                             license: "https://openexchangerates.org/license",
                             timestamp: 1660572000,
                             base: "USD",
                             rates: [
                              "AED": 3.6731
                             ])
  }
  static func getCurrencyListVM() -> CurrencyListViewModel{
    return  CurrencyListViewModel()
  }
}
