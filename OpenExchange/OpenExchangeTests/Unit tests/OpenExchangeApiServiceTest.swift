//
//  ApiServiceTest.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 15/08/22.
//

@testable import OpenExchange
import XCTest

class OpenExchangeApiServiceTest: XCTestCase {
  
  private var apiService:OpenExchangeApiService!

    override func setUpWithError() throws {
      try super.setUpWithError()
      apiService = OpenExchangeApiService()
    }

    override func tearDownWithError() throws {
      try super.tearDownWithError()
      apiService = nil
    }
  
  func test_apiRequest(){
    let request = apiService.getApiRequest(endPoint: .latest, queryParameters: [])
    XCTAssertEqual(request?.url?.scheme, OpenExchangeTestConstant.test_scheme)
    XCTAssertEqual(request?.url?.path, OpenExchangeTestConstant.test_path)
    XCTAssertEqual(request?.url?.host, OpenExchangeTestConstant.test_host)
  }
  
  func test_apiCall_response_not_nil(){
    
    let endPoint:EndPoint = .latest
    let queryParameter:[QueryParameter] = []
    var response:CurrencyListModel?
    let expection = self.expectation(description: "Proper response")
    
    apiService.apiCall(endPoint: endPoint, queryParams: queryParameter, objectType: CurrencyListModel.self) { model, error in
      response = model
      expection.fulfill()
    }
    waitForExpectations(timeout: 60, handler: nil)
    XCTAssertNotNil(response)
  }
  
  func test_apiCall_base_Not_nil(){
    
    let endPoint:EndPoint = .latest
    let queryParameter:[QueryParameter] = []
    var response:CurrencyListModel?
    let expection = self.expectation(description: "Proper response")
    
    apiService.apiCall(endPoint: endPoint, queryParams: queryParameter, objectType: CurrencyListModel.self) { model, error in
      response = model
      expection.fulfill()
    }
    waitForExpectations(timeout: 60, handler: nil)
    XCTAssertNotNil(response?.base)
  }
  
  func test_apiCall_error_nil(){
    let endPoint:EndPoint = .latest
    let queryParameter:[QueryParameter] = []
    var error:Error?
    let expection = self.expectation(description: "Proper response")
    
    apiService.apiCall(endPoint: endPoint, queryParams: queryParameter, objectType: CurrencyListModel.self) { model, err in
      error = err
      expection.fulfill()
    }
    waitForExpectations(timeout: 60, handler: nil)
    XCTAssertNil(error)
  }
}
