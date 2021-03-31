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
            "x-rapidapi-key":"e9dc41716fmsh809957099687bb8p1e3681jsn3279975abe4a",
//            "x-rapidapi-key": "d104cf1983mshf9c42424657e497p168e11jsn4a67213796a2",
            "x-rapidapi-host": "google-translate1.p.rapidapi.com"
        ]
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = method.value
        request.allHTTPHeaderFields = headers
        
        
        switch self {
        case .getTranslation(let text, let source, let target):
//            var param = [String:Any]()
//            param["q"] = text
//            param["source"] = source
//            param["target"] = target
            
            let postData = NSMutableData(data: "q=\(text)".data(using: String.Encoding.utf8)!)
            postData.append("&source=\(source)".data(using: String.Encoding.utf8)!)
            postData.append("&target=\(target)".data(using: String.Encoding.utf8)!)
            
            request.httpBody = postData as Data
            return request
            
        }
    }
}
