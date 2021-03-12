//
//  ServerRequestRouter.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 12/03/21.
//

import Foundation

enum ServerRequestRouter{
    case getTranslation(String,String,String)
    
    public static let baseURLString = "https://google-translate1.p.rapidapi.com/language"
    
    private enum HTTPMethod {
        case get
        case post
        case put
        case delete
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .put: return "PUT"
            case .delete: return "DELETE"
            }
        }
    }
    
    private var method:HTTPMethod{
        switch self {
        case .getTranslation:
            return .post
        }
    }
    
    private var path: String {
        switch self {
        case .getTranslation:
            return "/translate/v2"
        }
    }
    
    func request() throws -> URLRequest? {
        let urlString = "\(ServerRequestRouter.baseURLString)\(path)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "accept-encoding": "application/gzip",
            "x-rapidapi-key": "d104cf1983mshf9c42424657e497p168e11jsn4a67213796a2",
            "x-rapidapi-host": "google-translate1.p.rapidapi.com"
        ]
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = headers
        
        
        switch self {
        case .getTranslation(let text, let source, let target):
            var param = [String:Any]()
            param["q"] = text
            param["source"] = source
            param["target"] = target
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            return request
            
        }
    }
}
