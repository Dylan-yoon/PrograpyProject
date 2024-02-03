//
//  NetworkManager.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/1/24.
//

import Foundation
import UIKit

class NetworkManager {
    
    static func fetchData(api: UnsplashAPI, completion: @escaping (Result<[MainImageDataDTO], NetworkError>) -> Void) {
        
        guard let url = api.generateURL().url else {
            completion(.failure(.apiError))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.defaultsError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }
            
            debugPrint(response.statusCode)
            
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
    
    static func fetchImage(urlString: String, completion: @escaping (Result<(UIImage), NetworkError>) -> Void) {
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
            print(image)
            completion(.success(image))
        }.resume()
    }
    
//    static func fetchImages(imageCount: Int, completion: @escaping (Result<([UIImage]), NetworkError>) -> Void) {
//        let url = UnsplashAPI.random(count: imageCount)
//        
//        fetchData(api: url) { result in
//            switch result {
//            case .success(let datas):
//                
//                var imageDatas = [UIImage]()
//                
//                for data in datas {
//                    guard let imageURL = URL(string: data.urls.regular) else { return }
//                    
//                    URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
//                        if let error = error {
//                            debugPrint("Error downloading image: \(error.localizedDescription)")
//                            return
//                        }
//
//                        guard let data = data, let image = UIImage(data: data) else {
//                            print("Invalid image data or unable to create UIImage.")
////                            completion(.failure(.getDataError))
//                            return
//                        }
//                        
//                        imageDatas.append(image)
//                    }.resume()
//                }
//                
//                completion(.success(imageDatas))
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
}

enum NetworkError: Error {
    case apiError
    case defaultsError
    case responseError
    case JSONDecoderError
    case getDataError
}
