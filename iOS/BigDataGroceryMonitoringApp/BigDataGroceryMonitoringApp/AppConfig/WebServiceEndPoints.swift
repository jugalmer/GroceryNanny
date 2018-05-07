//
//  EndPoints.swift
//  BigDataGroceryMonitoringApp


import Foundation

/// WebServiceEndPointsError are of type Error, thrown if the endpoint is not found in local json configuration file
public enum WebServiceEndPointsError: Error {
    
    case emptyOrCorruptGlobalAPIGatewayEndPoint
    case emptyOrCorruptSearchAPI
    
    public var description: String {
        switch self {
        case .emptyOrCorruptGlobalAPIGatewayEndPoint: return "Empty or Corrupt gloabl endpoint in App Config file"
        case .emptyOrCorruptSearchAPI: return "Empty or Corrupt search API in App config file"
        }
    }
}

///  WebServiceEndPoints provides with host, api values from local json configuration file
public struct WebServiceEndPoints {
    
    /// Computed Properties
    let endPoints: Dictionary<String, Any>
    
    public func globalAPISearchGatewayEndPoint() throws -> String {
        guard
            let endPointGlobals = self.endPoints["global"] as? [String: Any],
            let endPoint = endPointGlobals["apiSearchGateway"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptGlobalAPIGatewayEndPoint
        }
        return endPoint
    }
    
    /// Returns search API from config file
    public func searchAPIEndpoint() throws -> String {
        guard
            let apis = self.endPoints["api"] as? [String: Any],
            let api = apis["search"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptSearchAPI
        }
        return api
    }
    
    public func globalAPIRecommendationGatewayEndPoint() throws -> String {
        guard
            let endPointGlobals = self.endPoints["global"] as? [String: Any],
            let endPoint = endPointGlobals["apiRecommendation"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptGlobalAPIGatewayEndPoint
        }
        return endPoint
    }
    
    /// Returns search API from config file
    public func recommendationAPIEndpoint() throws -> String {
        guard
            let apis = self.endPoints["api"] as? [String: Any],
            let api = apis["recommendation"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptSearchAPI
        }
        return api
    }
    
    public func homeAPIEndpoint() throws -> String {
        guard
            let apis = self.endPoints["api"] as? [String: Any],
            let api = apis["home"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptSearchAPI
        }
        return api
    }
    
    ///Public Init Method
    public init(endPoints: Dictionary<String, Any>) {
        self.endPoints = endPoints
    }
    
}
