//
//  APIOperation.swift
//  WeatherApp
//
//  Created by Brandon Shega on 5/26/16.
//  Copyright © 2016 Brandon Shega. All rights reserved.
//

enum HTTPMethod: String {
    case POST = "POST"
    case GET = "GET"
}

import Foundation

class APIOperation: NSOperation {
    
    //MARK: - Variables
    
    private var apiString: String = ""
    private var httpMethod: HTTPMethod = .POST
    
    var successCallback: ((AnyObject) -> ())?
    var failureCallback: ((NSError?) -> ())?
    
    lazy internal var urlSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPMaximumConnectionsPerHost = 1
        configuration.requestCachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        configuration.timeoutIntervalForResource = NSTimeInterval(12)
        
        let urlSession = NSURLSession(configuration: configuration)
        return urlSession
    }()
    
    init(url: String) {
        apiString = url
        super.init()
    }
    
    init(url: String, method: HTTPMethod) {
        apiString = url
        httpMethod = method
        super.init()
    }
    
    //MARK: - Overrides
    override func start() {
        download()
    }
    
    //MARK: - Functions
    func download() {
        
        guard let url = NSURL(string: apiString) else { fatalError("Could not convert url") }
        let urlRequest = NSURLRequest(URL: url)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) in
            
            guard let httpResponse = response as? NSHTTPURLResponse else { return }
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                
                do {
                    
                    guard let data = data else { return }
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    self.reportSucces(json)
                    
                } catch let error as NSError {
                    self.reportFailure(error)
                }
                
            }
        }
        
        task.resume()
        
    }
    
    func reportSucces(data: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) { 
            self.successCallback?(data)
        }
    }
    
    func reportFailure(error: NSError?) {
        dispatch_async(dispatch_get_main_queue()) { 
            self.failureCallback?(error)
        }
    }
    
}
