//
//  CurrencyConverterProtocol.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 12/08/22.
//

import Foundation

protocol CurrencyConverterProtocol:AnyObject{
  var globalBaseCurrency:String{set get}
  var baseCurrency:String{get set}
  var baseCurrencyValue:Double {get set}
  func convert(amount:Double, currencyValue:Double) -> Double
}
