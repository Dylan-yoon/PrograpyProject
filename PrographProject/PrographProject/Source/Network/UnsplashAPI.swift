//
//  UnsplashAPI.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/11/24.
//

import Foundation

final class UnsplashAPI {
    private let client = URLQueryItem(name: "client_id", value: "IxQ_JAE-x1Cx0UuHVg_jXoPWYWi_nGXcjVSyqDXYLhI")
    
    enum OrderBy: String {
        case latest, oldest, popular
    }
    
    func fetchDatas(_ page: Int, _ per_page: Int, _ order_by: OrderBy = .latest, completion: @escaping (Result<[MainImageDataDTO], UnsplashAPIError>) -> Void) {
        let page = URLQueryItem(name: "page", value: "\(page)")
        let perPage = URLQueryItem(name: "per_page", value: "\(per_page)")
        let orderBy = URLQueryItem(name: "order_by", value: "\(order_by.rawValue)")
        let endPoint = EndPoint(baseURL: "api.unsplash.com", path: "/photos", queryItems: [client, page, perPage, orderBy])
        
        NetworkManager.shared.fetchData(with: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode([MainImageDataDTO].self, from: data)
                    
                    completion(.success(decodedData))
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData(with id: String, completion: @escaping (Result<MainImageDataDTO, UnsplashAPIError>) -> Void) {
        let endPoint = EndPoint(baseURL: "api.unsplash.com", path: "/photos/\(id)",queryItems: [client])
        
        NetworkManager.shared.fetchData(with: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(MainImageDataDTO.self, from: data)
                    
                    completion(.success(decodedData))
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchRandomPhoto(count: Int, completion: @escaping (Result<[MainImageDataDTO], UnsplashAPIError>) -> Void) {
        let count = URLQueryItem(name: "count", value: "\(count)")
        let endPoint = EndPoint(baseURL: "api.unsplash.com", path: "/photos", queryItems: [client, count])
        
        NetworkManager.shared.fetchData(with: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode([MainImageDataDTO].self, from: data)
                    
                    completion(.success(decodedData))
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

enum UnsplashAPIError: Error {
    case networkError
}
