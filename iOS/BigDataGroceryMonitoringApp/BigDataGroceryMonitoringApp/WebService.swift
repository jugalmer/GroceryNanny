//
//  WebService.swift
//  BigDataGroceryMonitoringApp

import Foundation

/**
 Response object for a WebService call.
 HTTP Response statusCode, Response Body, and URL of the WebService call are availble from this object.
 */
public class WebServiceResponse {
    public let statusCode   : Int
    public let body         : Data // data from http response
    public let url          : URL?
    
    /**
     Convenient acces to the http response obj in case needed
     */
    public let httpResponse : URLResponse
    
    public init(statusCode: Int, url: URL?, body: Data, httpResponse: URLResponse) {
        self.statusCode   = statusCode
        self.body         = body
        self.url          = url
        self.httpResponse = httpResponse
    }
}
/**
 * Error object for a WebService call
 * HTTP Response statusCode, Response instance, and Error of the WebService call are availble from this object
 */
public class WebServiceError: Error {
    public let httpErrorCode: Int
    public let httpResponse : HTTPURLResponse?
    public let responseBody : Data?
    public let error        : NSError?
    
    public init(httpErrorCode: Int, httpResponse: HTTPURLResponse?, responseBody: Data?, error: NSError?) {
        self.httpErrorCode = httpErrorCode
        self.httpResponse  = httpResponse
        self.responseBody  = responseBody
        self.error         = error
    }
}

public typealias WebServiceSuccessHandler = (_ response: WebServiceResponse) -> Void
public typealias WebServiceErrorHandler   = (_ error: WebServiceError?) -> Void

/// public API for web Service
class WebService: NSObject, URLSessionDelegate {
    let timeOut : Double = 30 ///Default web service timeout (in seconds)
    let maxAttempts : UInt = 3 ///If service call fails try maximum of three times.
    var attempt = 0 /// Initial attempt of web service call
    
    /// This method, executes the web service call
    ///
    /// - Parameters:
    ///   - endPoint: of type String, loaded from local config
    ///   - api: of type String, loaded from local Config
    ///   - urlParams: of type Dictionary. It gets attached to request url
    ///   - successCallback: This closure is called on succesful execution of web service call
    ///   - errorCallback: This closure is called on failure of web service call
    func execute(endPoint: String?, api: String?, urlParams : Dictionary<String, Any>?, service: String? = nil, bodyParams: Any?, httpMethod: String, successCallback: @escaping WebServiceSuccessHandler, errorCallback: @escaping WebServiceErrorHandler) {
        var request : URLRequest
        let url: URL
        attempt += 1
        guard let endPoint = endPoint, let api = api else { return }
        let urlStr = endPoint + api
        
        if let urlParams = urlParams {
            url = URL(string: (endPoint + api) + "?" + urlParams.stringFromHttpParameters())!
        } else {
            if let constructedURL = URL(string: urlStr) {
                url = constructedURL
            } else {
                return /// Return as there is no valid url constructed
            }
        }
        // building the request
        request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(timeOut))
        request.httpMethod = httpMethod
        
        if let serv = service, serv == "search" {
            let username = "elastic"
            let password = "Rz7ttlR5OK4JDAg0hyl92wwc"
            let loginString = NSString(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8.rawValue)!
            let base64LoginString = loginData.base64EncodedString()
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            
        }
        
        // constructing request body
        if (httpMethod == "POST"  && bodyParams != nil) {
            request.httpBody = self.convertToJSONData(bodyParams! as AnyObject)!
            request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            //        request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        ///Execute network call
        let sessionConfig = URLSessionConfiguration.default
        let session = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response else {
                session.invalidateAndCancel()
                guard let nsError = error as NSError? else { return }
                ///Try max attempts, if done then call errorCallback
                guard nsError.code == NSURLErrorTimedOut, self.attempt < self.maxAttempts else {
                    let wsError = WebServiceError(httpErrorCode: nsError.code, httpResponse: nil, responseBody: nil, error: nsError)
                    errorCallback(wsError)
                    return
                    
                }
                // self.execute(endPoint: endPoint, api: api, urlParams : urlParams, successCallback: successCallback, errorCallback: errorCallback)
                return
            }
            let httpResponse: HTTPURLResponse = response as! HTTPURLResponse
            // only consider statusCode 2xx as successful, all other cases need to handle as error for webservice call
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                
                // building obj WebServiceResponse
                let res = WebServiceResponse(statusCode: httpResponse.statusCode, url: httpResponse.url, body: data, httpResponse: response)
                session.invalidateAndCancel()
                // invoke callback for success handling
                successCallback(res)
                
            } else {
                let wsError = WebServiceError(httpErrorCode: httpResponse.statusCode, httpResponse: httpResponse, responseBody: data, error: (error as NSError?))
                session.invalidateAndCancel()
                // invoke callback for error handling
                errorCallback(wsError)
            }
            
        }
        task.resume()
    }
    
    open func convertToJSONData(_ o: AnyObject) -> Data? {
        if (JSONSerialization.isValidJSONObject(o)) {
            return try! JSONSerialization.data(withJSONObject: o, options: .prettyPrinted)
        }
        
        return nil
    }
}
// MARK: - Extension
extension String {
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// :returns: Returns percent-escaped string.
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
}
extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let valueString = String(describing: value)
            let percentEscapedValue = valueString.stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}
