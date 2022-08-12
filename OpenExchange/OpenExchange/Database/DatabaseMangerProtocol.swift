//
//  DatabaseMangerProtocol.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 13/08/22.
//

import Foundation

protocol DatabaseMangerProtocol:AnyObject{
  associatedtype T
  associatedtype V
  
  var getDataManager:T{get}
  func saveData<U:Codable>(data:U)
  func getData() -> [V]?
  func deleteData()
}
