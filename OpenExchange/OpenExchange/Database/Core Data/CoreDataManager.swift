//
//  CoreDataManager.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 12/08/22.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager: DatabaseMangerProtocol{
  typealias T = NSManagedObjectContext
  
  typealias V = NSManagedObject
  
  var appDelegate:AppDelegate{
    return UIApplication.shared.delegate as! AppDelegate
  }
  
  var getDataManager: NSManagedObjectContext{
    
    return appDelegate.persistentContainer.viewContext
  }
  
  func saveData<U>(data: U) {
  
    guard let model: CurrencyListModel = data as? CurrencyListModel else {return}
    let currencyData = CurrencyRate(context: getDataManager)
    currencyData.timestamp = Date().currentTimeMillis()
    currencyData.globalBase = model.base
    
    var rates:[Rate] = []
    
    let allKeys = model.rates?.keys.map{String($0)}
    
    for key in allKeys ?? []{
      if let value = model.rates?[key]{
        let rate = Rate(context: getDataManager)
        rate.name = key
        rate.value = value
        rates.append(rate)
      }
    }
    
    currencyData.rates = NSSet(array: rates)
    appDelegate.saveContext()
  }
  
  func getData() -> [NSManagedObject]? {
    let fetchRequest = NSFetchRequest<CurrencyRate>(entityName: "CurrencyRate")
    do{
      let fetchResults = try getDataManager.fetch(fetchRequest)
      return fetchResults
    }catch{
      print("Error while fetching data!!!")
    }
    return nil
  }
  func deleteData() {

  }
}
