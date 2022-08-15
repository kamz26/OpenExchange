//
//  CurrencyListViewModel.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 10/08/22.
//

import Foundation
import UIKit

final class CurrencyListViewModel:CurrencyListViewModelProtocol{
  private(set) var currencyService:LatestCurrencyApiServiceProtocol!
  private(set) var currencyConverter:CurrencyConverterProtocol!
  private(set) var currencyModel:CurrencyRate?
  private(set) var dbManager: some DatabaseMangerProtocol & SyncManagerProtocol = CoreDataManager()
  private(set) var currentAmount:Double!
  private(set) var currentCurrency:String!
  weak var currencyListUpdateDelegate:CurrencyListUpdateProtocol?
  weak var converterDelegate:CurrencyconversionUpdateProtocol?
  
  var currentEnteredAmount:Double?{
    get{
      return currentAmount
    }
    set{
      currentAmount = newValue ?? -1 > 0 ? newValue : nil
      converterDelegate?.updateConversionList()
    }
  }
  var currentCurrecySelected:String{
    get{
      return currentCurrency
    }
    set{
      currentCurrency = newValue
      currencyConverter.baseCurrency = currentCurrency
      if let value = getCurreciesWithAmount[currentCurrency]{
        currencyConverter.baseCurrencyValue = value
      }
      converterDelegate?.updateConversionList()
    }
    
  }
  
  var currenciesCount: Int{
    get{
      if let model = currencyModel, let rates = model.rates{
        return rates.count
      }
      return 0
    }
  }
  
  var getCurrenciesList: [String]{
    get{
      if let model = currencyModel, let rates = model.rates {
        var currencies:[String] = []
        for item in rates{
          if let rate = item as? Rate{
            currencies.append(rate.name ?? "")
          }
        }
        return currencies.sorted()
      }
      return []
    }
  }
  
  var getCurreciesWithAmount:[String:Double]{
    get{
      if let model = currencyModel, let rates = model.rates {
        let arrData = Array(rates) as? [Rate]
        if let arr = arrData{
        let dict = arr.reduce(into: [String:Double]()) {
          $0[$1.name ?? ""] = $1.value
        }
          return dict
        }
      }
      return [:]
    }
  }
  
  init(service:LatestCurrencyApiServiceProtocol = LatestCurrencyApiService(),
       converter:CurrencyConverterProtocol = CurrencyConverter(),
       updateDelegate:CurrencyListUpdateProtocol? = nil,
       convertUpdateDelegate: CurrencyconversionUpdateProtocol? = nil){
    self.currencyService = service
    self.currencyConverter = converter
    self.currencyListUpdateDelegate = updateDelegate
    self.converterDelegate = convertUpdateDelegate
  }
  
  
  func getCurrenciesData() {
    if self.dbManager.isSyncRequired(){
      print("fetched from API")
      fetchlatestCurrencyData()
    }else{
      print("fetched from local")
      fetchPersistedCurrencyData()
    }
  }
  
  fileprivate func fetchlatestCurrencyData(){
    currencyService.getLatestCurrenciesData {[weak self] currencyListModel, error in
      guard let safeSelf = self else {return}
      DispatchQueue.main.async {
        safeSelf.dbManager.deleteData()
        safeSelf.dbManager.saveData(data: currencyListModel)
        safeSelf.fetchPersistedCurrencyData()
      }
    }
  }
  
  fileprivate func fetchPersistedCurrencyData(){
    if let currencyData = dbManager.getData()?.first as? CurrencyRate{
      currencyModel = currencyData
      currencyConverter.baseCurrency = currencyData.globalBase ?? "USD"
      currencyListUpdateDelegate?.didUpdateCurrencyList()
    }
  }
  
  func getAmountForCurrency(curreny:String) -> Double{
    if let value = getCurreciesWithAmount[curreny], let enteredAmount = currentEnteredAmount{
      return currencyConverter.convert(amount: enteredAmount, currencyValue: value)
    }
    return -1.0
  }
}
