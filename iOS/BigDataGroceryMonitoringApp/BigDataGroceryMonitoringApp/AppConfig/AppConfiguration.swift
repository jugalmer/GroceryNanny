//
//  AppConfiguration.swift
//  BigDataGroceryMonitoringApp

import Foundation

public class AppConfiguration {
    
    static let sharedInstance = AppConfiguration()
    /// Computed Properties
    private var responseData: Dictionary<String, Any> = [:]
    
    /// Reads endpoints from local config file and initializes WebServiceEndPoints, for further access of host, api
    var endPoints : WebServiceEndPoints? {
        get {
            if let endpoints = self.responseData["endpoint"] as? [String:Any], !endpoints.isEmpty {
                return WebServiceEndPoints(endPoints: endpoints)
            }
            return nil
        }
    }
    
    /// Loads default local configuration(config) file from AppConfig.json
    func loadDefaultConfiguration(){
        if let configPath = Bundle.main.path(forResource: "AppConfig", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: configPath), options: Data.ReadingOptions.mappedIfSafe)
                let parsedJson = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:AnyObject]
                if let parsedJSON = parsedJson {
                    responseData = parsedJSON
                } else {
                    print("Error while parsing data")
                }
            } catch let dataError as NSError {
                print("Error while getting data from main bundle: \(dataError.localizedDescription)")
            }
        }
        else {
            print("File doesn't exist")
        }
    }
}
