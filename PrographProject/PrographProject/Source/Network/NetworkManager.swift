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
            completion(.failure(.endPointError))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            //Error
            if error != nil {
                completion(.failure(.dataTaskError))
                return
            }
            
            //Response
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }
            
            switch response.statusCode {
            case 100...199:
                completion(.failure(.informationError))
            case 200...299:
                completion(.failure(.successfulError))
            case 300...399:
                completion(.failure(.redirectionError))
            case 400...499:
                completion(.failure(.clientError))
            case 500...599:
                completion(.failure(.serverError))
            default:
                completion(.failure(.unknownerror))
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
            completion(.failure(.endPointError))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            //Error
            if error != nil {
                completion(.failure(.dataTaskError))
                return
            }
            
            //Response
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }
            
            switch response.statusCode {
            case 100...199:
                completion(.failure(.informationError))
            case 200...299:
                completion(.failure(.successfulError))
            case 300...399:
                completion(.failure(.redirectionError))
            case 400...499:
                completion(.failure(.clientError))
            case 500...599:
                completion(.failure(.serverError))
            default:
                completion(.failure(.unknownerror))
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
    case endPointError
    case dataTaskError
    case responseError
    case getDataError
    case unknownerror
    case informationError
    case successfulError
    case redirectionError
    case clientError
    case serverError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .endPointError:
            return "Invaild URL"
        case .dataTaskError:
            return "DataTask Error"
        case .responseError:
            return "Response Error"
        case .getDataError:
            return "Data Error"
        case .unknownerror:
            return "Unknown Error"
        case .informationError:
            return "Information responses"
        case .successfulError:
            return "Successful responses"
        case .redirectionError:
            return "Redirection messages"
        case .clientError:
            return "Client error responses"
        case .serverError:
            return "Server error responses"
        }
    }
}
