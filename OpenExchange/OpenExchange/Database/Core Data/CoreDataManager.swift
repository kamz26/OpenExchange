//
//  CoreDataManager.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 12/08/22.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager: DatabaseMangerProtocol,SyncManagerProtocol{
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
    guard getData()?.first != nil else {return}
    
    let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrencyRate")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
    do
    {
        try getDataManager.execute(deleteRequest)
        try getDataManager.save()
    }
    catch
    {
        print ("There was an error")
    }
  }
  
  func isSyncRequired() -> Bool {
    if let currentData = self.getData()?.first as? CurrencyRate {
      let lastSyncedTimestamp = currentData.timestamp
      let currentTimeStamp = Date().currentTimeMillis()
      
      let diff = currentTimeStamp - lastSyncedTimestamp
      
      return diff > 1800000 // fetch once in 30 min
      
    }
    return true
  }
}
