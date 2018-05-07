//
//  GroceryModel.swift
//  BigDataGroceryMonitoringApp

import Foundation

typealias ResourceDictionary = Dictionary<String, AnyObject>

class SearchExternalModel {

  var responseDictionary: ResourceDictionary = [:]

  init(dataItems: ResourceDictionary) {
    self.responseDictionary = dataItems
  }
  lazy var hits: [Any] = {
    let hits = responseDictionary["hits"] as? ResourceDictionary ?? [:]
    let internalHits = hits["hits"] as? Array<Any> ?? []
    return internalHits
  }()
}

class SearchInternalModel {

  var responseDictionary: ResourceDictionary = [:]

  init(dataItems: ResourceDictionary) {
    self.responseDictionary = dataItems
  }

  lazy var productName: String = {
    guard let sys = responseDictionary["_source"] as? ResourceDictionary else { return "" }
    return sys["product_name"] as? String ?? ""
  }()
  
  lazy var id: Int = {
    guard let sys = responseDictionary["_source"] as? ResourceDictionary else { return 0 }
    return sys["id"] as? Int ?? 0
  }()
  
  
}

class RecommendationModel {
  var responseDictionary: ResourceDictionary = [:]

  init(dataItems: ResourceDictionary) {
    self.responseDictionary = dataItems
  }
  
  let dateRange: [String] = ["2018-05-07", "2018-05-08", "2018-05-06"]
  let priceRange = [2, 3, 4, 5, 2.5]
  
  lazy var productName: String = {
    return responseDictionary["product_name"] as? String ?? ""
  }()
  
  lazy var productImage: String = {
    return responseDictionary["product_img"] as? String ?? ""
  }()
 
  lazy var productId: Int = {
    return responseDictionary["product_id"] as? Int ?? 0
  }()
  
  lazy var userId: Int = {
    return responseDictionary["product_name"] as? Int ?? 0
  }()
  
  lazy var date: String = {
    return dateRange[Int(arc4random_uniform(UInt32(dateRange.count)))]
  }()
  
  lazy var price: Int = {
    return Int(priceRange[Int(arc4random_uniform(UInt32(priceRange.count)))])
  }()
  
  lazy var cost: Int = {
    if let cost = responseDictionary["cost"] as? Double {
      return Int(cost)
    }
    return 0
  }()
  
  lazy var expiry: String = {
    return responseDictionary["expiry"] as? String ?? ""
  }()
  
}

