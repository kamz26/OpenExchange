//
//  CurrencyListViewModelProtocol.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 12/08/22.
//

import Foundation


protocol CurrencyListUpdateProtocol:AnyObject{
    func didUpdateCurrencyList()
}

protocol CurrencyconversionUpdateProtocol:AnyObject{
  func updateConversionList()
}
protocol CurrencyListViewModelProtocol{
  var currentEnteredAmount:Double?{get set}
  var currentCurrecySelected:String{ get set}
  var currenciesCount:Int{get}
  var getCurrenciesList:[String] {get}
  func getCurrenciesData()
  func getAmountForCurrency(curreny:String) -> Double
}
