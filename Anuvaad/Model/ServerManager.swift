//
//  ServerManager.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 12/03/21.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case parsingError
    case badRequest
}

struct ServerManager {
    static let shared = ServerManager()
    
    private let config: URLSessionConfiguration
    private let session: URLSession
    
    private init() {
        config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func request<T: Decodable>(router: ServerRequestRouter, completion: @escaping (Result<T,NetworkError>) -> ()) {
        do {
            if let request = try router.request(){
                let task = session.dataTask(with: request) { (data, urlResponse, error) in
                    DispatchQueue.main.async {
                        
                        if error != nil {
                            completion(.failure(.badURL))
                            return
                        }
                        
                        guard let data = data else {
                            completion(.failure(.badRequest))
                            return
                        }
                        
                        do {
//                            print(String(data: data, encoding: .utf8))
                            let result = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(result))
                        } catch {
                            completion(.failure(.parsingError))
                        }
                    }
                }
                task.resume()
            }
        } catch {
            completion(.failure(.badRequest))
        }
    }
}

extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
    
    
}
