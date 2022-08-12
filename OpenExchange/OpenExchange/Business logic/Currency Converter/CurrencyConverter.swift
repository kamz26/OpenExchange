//
//  CurrencyConverter.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 11/08/22.
//

import Foundation

class CurrencyConverter:CurrencyConverterProtocol{
  
  private(set) var currentBaseCurrency:String!
  private(set) var currenctBaseCurrencyValue:Double!
  private(set) var APIBaseCurrency:String!
  
  var baseCurrency: String{
    set{
      currentBaseCurrency = newValue
    }
    get{
      return currentBaseCurrency != nil ? currentBaseCurrency : "USD"
    }
  }
  
  var baseCurrencyValue: Double{
    set{
      currenctBaseCurrencyValue = newValue
    }
    get{
      return currenctBaseCurrencyValue != nil ? currenctBaseCurrencyValue : 1.0
    }
  }
  
  var globalBaseCurrency:String{
    set{
      APIBaseCurrency = newValue
    }
    get{
      return APIBaseCurrency != nil ? APIBaseCurrency : "USD"
    }
  }
  
  func convert(amount: Double, currencyValue:Double) -> Double{
    if baseCurrency != APIBaseCurrency{
      let multipleFactor = currencyValue / baseCurrencyValue
      return (amount * multipleFactor ).roundOfValue
    }
    
    return (amount * currencyValue).roundOfValue
  }
}
