//
//  UnsplashAPI.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/11/24.
//

import Foundation

final class UnsplashAPI {
    let client = URLQueryItem(name: "client_id", value: "IxQ_JAE-x1Cx0UuHVg_jXoPWYWi_nGXcjVSyqDXYLhI")
    
    enum OrderBy: String {
        case latest, oldest, popular
    }
    
    func fetchList(_ page: Int, _ per_page: Int, _ order_by: OrderBy = .latest, completion: @escaping (Result<Data, UnsplashAPIError>) -> Void) {
        let page = URLQueryItem(name: "page", value: "\(page)")
        let perPage = URLQueryItem(name: "per_page", value: "\(per_page)")
        let orderBy = URLQueryItem(name: "order_by", value: "\(order_by.rawValue)")
        let endPoint = EndPoint(baseURL: "api.unsplash.com", path: "/photos", queryItems: [page, perPage, orderBy])
        
        NetworkManager.shared.fetchData1(with: endPoint) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData(with id: String) {
        
    }
    
    // 1~30
    func fetchRandomPhoto(count: Int) {
        
    }
    
//    let decodedData = try jsonDecoder.decode(MainImageDataDTO.self, from: data)
}

enum UnsplashAPIError: Error {
    case networkError
}
