//
//  NetworkManager.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/1/24.
//

import UIKit

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
    
    func TODO_DELETE_fetchData(with api: UnsplashAPIEndPoint, completion: @escaping (Result<[MainImageDataDTO], NetworkError>) -> Void) {
        guard let url = api.generateURL().url else {
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
            
            debugPrint(response.statusCode)
            
            //Data
            guard let data = data else {
                completion(.failure(.getDataError))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                switch api {
                case .id:
                    let decodedData = try jsonDecoder.decode(MainImageDataDTO.self, from: data)
                    completion(.success([decodedData]))
                case .main, .random:
                    let decodedData = try jsonDecoder.decode([MainImageDataDTO].self, from: data)
                    completion(.success(decodedData))
                }
            } catch {
                print(NetworkError.JSONDecoderError.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    //TODO: Delete
    func fetchImage(urlString: String, completion: @escaping (Result<(UIImage), NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.apiError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                print("Invalid image data or unable to create UIImage.")
                return
            }
            completion(.success(image))
        }.resume()
    }
}

enum NetworkError: Error {
    case apiError
    case defaultsError
    case responseError
    case JSONDecoderError
    case getDataError
}
