//
//  NetworkManager.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/1/24.
//

import Foundation
/*
 Main            https://api.unsplash.com/photos
 RandomPhoto     https://api.unsplash.com/photos/random
 Detail GET      https://api.unsplash.com/photos/:id
 */

class NetworkManager {
    
    static func fetchData(completion: @escaping (Result<[MainImageDataDTO], NetworkError>) -> Void) {
        //URL 수정 Page, per_page, order_by(Valid values: latest, oldest, popular; default: latest)
        let testUrl = "https://api.unsplash.com/photos/?client_id=IxQ_JAE-x1Cx0UuHVg_jXoPWYWi_nGXcjVSyqDXYLhI&page=1&per_page=2"
        
        let url = URL(string: testUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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
                let decodedData = try jsonDecoder.decode([MainImageDataDTO].self, from: data)
                completion(.success(decodedData))
            } catch {
                print(NetworkError.JSONDecoderError.localizedDescription)
            }
        }
        
        task.resume()
    }
}

enum NetworkError: Error {
    case defaultsError
    case responseError
    case JSONDecoderError
    case getDataError
}
