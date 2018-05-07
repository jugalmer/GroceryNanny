//
//  GroceryViewModel.swift
//  BigDataGroceryMonitoringApp

import Foundation
import UIKit

///Genric completion Handler
public typealias ServiceCompletionHandler<T> = (ServiceResult<T>) -> ()

///Generic Enum, can be used as completion handler for any
public enum ServiceResult<T> {
  case success(T)
  case failure(Error)
}
class GroceryViewModel: NSObject, URLSessionDelegate {

  func fetchHome(withCompletion completion: @escaping ServiceCompletionHandler<[RecommendationModel]>)  throws -> Void {
    do {
      let config = AppConfiguration.sharedInstance
      let endPoint = try config.endPoints?.globalAPIRecommendationGatewayEndPoint()
      let api = try config.endPoints?.homeAPIEndpoint()
      
      WebService().execute(endPoint: endPoint, api: api, urlParams: nil, bodyParams: nil, httpMethod: "GET", successCallback: { (response: WebServiceResponse) in
        
        guard let responseDictionary = self.parseToArray(response.body) else {
          print(" : Fail to convert data to json \(response.body)")
          return
        }
        var result : [RecommendationModel] = []
        for items in responseDictionary {
          if let itemDict = items as? ResourceDictionary {
            let itemConstructed = RecommendationModel.init(dataItems: itemDict)
            result.append(itemConstructed)
          }
        }
        completion(.success(result))
      }, errorCallback: { (serviceError: WebServiceError?) in
        //error code
        if let serviceError = serviceError {
          completion(.failure(serviceError))
        }
      })
    } catch let error {
      print(": Error in search service : \(error)")
      completion(.failure(error))
    }
  }
  
  func fetchRecommendation(withCompletion completion: @escaping ServiceCompletionHandler<[RecommendationModel]>)  throws -> Void {
    do {
      let config = AppConfiguration.sharedInstance
      let endPoint = try config.endPoints?.globalAPIRecommendationGatewayEndPoint()
      let api = try config.endPoints?.recommendationAPIEndpoint()
      
      WebService().execute(endPoint: endPoint, api: api, urlParams: nil, bodyParams: nil, httpMethod: "GET", successCallback: { (response: WebServiceResponse) in
        
        guard let responseDictionary = self.parseToArray(response.body) else {
          print(" : Fail to convert data to json \(response.body)")
          return
        }
        var result : [RecommendationModel] = []
        for items in responseDictionary {
          if let itemDict = items as? ResourceDictionary {
            let itemConstructed = RecommendationModel.init(dataItems: itemDict)
            result.append(itemConstructed)
          }
        }
        completion(.success(result))
      }, errorCallback: { (serviceError: WebServiceError?) in
        //error code
        if let serviceError = serviceError {
          completion(.failure(serviceError))
        }
      })
    } catch let error {
      print(": Error in search service : \(error)")
      completion(.failure(error))
    }
  }
  
  
  func fetchSearchResults(forValue value: String, withCompletion completion: @escaping ServiceCompletionHandler<[SearchInternalModel]>)  throws -> Void {
    do {
      let config = AppConfiguration.sharedInstance
      let endPoint = try config.endPoints?.globalAPISearchGatewayEndPoint()
      let api = try config.endPoints?.searchAPIEndpoint()
      
      //construct body param
      let bodyParams: [String: Any] = [
        "query": [
          "match": [
            "all": value
          ]
        ]
      ]
      
      WebService().execute(endPoint: endPoint, api: api, urlParams: nil, service: "search", bodyParams: bodyParams, httpMethod: "POST", successCallback: { (response: WebServiceResponse) in
     
        guard let responseDictionary = self.parseToDictionary(response.body) else {
          print(" : Fail to convert data to json \(response.body)")
          return
        }
        let searchModel = SearchExternalModel(dataItems: responseDictionary)
        let hits = searchModel.hits
        var result : [SearchInternalModel] = []
        for items in hits {
          if let itemDict = items as? ResourceDictionary {
            let itemConstructed = SearchInternalModel.init(dataItems: itemDict)
            result.append(itemConstructed)
          }
        }
        completion(.success(result))
      }, errorCallback: { (serviceError: WebServiceError?) in
        //error code
        if let serviceError = serviceError {
          completion(.failure(serviceError))
        }
      })
    } catch let error {
      print(": Error in search service : \(error)")
      completion(.failure(error))
    }
  }
  
  func addGrocery(pid: Int, pname: String, pcost: Int, pexp: String, withCompletion completion: @escaping ServiceCompletionHandler<Bool>)  throws -> Void {
    do {
      let config = AppConfiguration.sharedInstance
      let endPoint = try config.endPoints?.globalAPIRecommendationGatewayEndPoint()
      let api = try config.endPoints?.homeAPIEndpoint()
      
      //construct body param
     let bodyParams: [String: Any] = [
        "product_id":pid,
        "product_name": pname,
        "cost":pcost,
        "expiry":pexp
      ]
      
      WebService().execute(endPoint: endPoint, api: api, urlParams: nil, bodyParams: bodyParams, httpMethod: "POST", successCallback: { (response: WebServiceResponse) in
       
        completion(.success(true))
      }, errorCallback: { (serviceError: WebServiceError?) in
        //error code
        if let serviceError = serviceError {
          completion(.failure(serviceError))
        }
      })
    } catch let error {
      print(": Error in search service : \(error)")
      completion(.failure(error))
    }
  }

  private func parseToDictionary(_ data: Data) -> [String:AnyObject]? {
    let parsedJson = try? JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:AnyObject]
    
    if parsedJson != nil {
      return parsedJson!
    }
    
    return nil
  }
  
  private func parseToArray(_ data: Data) -> [AnyObject]? {
    let parsedJson = try? JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [AnyObject]
    
    if parsedJson != nil {
      return parsedJson!
    }
    
    return nil
  }

  
}

