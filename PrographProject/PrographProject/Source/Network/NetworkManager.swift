//
//  NetworkManager.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/1/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    private let urlSession = URLSession.shared
    
    func fetchData(with endPoint: EndPoint, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = endPoint.generateURL().url else {
            completion(.failure(.apiError))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            //Error
            if error != nil {
                completion(.failure(.defaultsError))
                return
            }
            
            //Response
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }
            
            switch response.statusCode {
            case 100...199:
                debugPrint("Information responses")
            case 200...299:
                debugPrint("Successful responses")
            case 300...399:
                debugPrint("Redirection messages")
            case 400...499:
                debugPrint("Client error responses")
            case 500...599:
                debugPrint("Server error responses")
            default:
                debugPrint("Unknown StatusCode Error")
            }
            
            //Data
            guard let data = data else {
                completion(.failure(.getDataError))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func fetchData(with url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.apiError))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            //Error
            if error != nil {
                completion(.failure(.defaultsError))
                return
            }
            
            //Response
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }
            
            switch response.statusCode {
            case 100...199:
                debugPrint("Information responses")
            case 200...299:
                debugPrint("Successful responses")
            case 300...399:
                debugPrint("Redirection messages")
            case 400...499:
                debugPrint("Client error responses")
            case 500...599:
                debugPrint("Server error responses")
            default:
                debugPrint("Unknown StatusCode Error")
            }
            
            //Data
            guard let data = data else {
                completion(.failure(.getDataError))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}

enum NetworkError: Error {
    case apiError
    case defaultsError
    case responseError
    case JSONDecoderError
    case getDataError
}
