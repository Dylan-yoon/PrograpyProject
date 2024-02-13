//
//  UnsplashAPI.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/2/24.
//

import Foundation

enum UnsplashAPIEndPoint {
    case main(page: Int, perPage: Int, orderBy: orderBy = .latest)
    case id(id: String)
    case random(count: Int)
    
    enum orderBy: String {
        case latest, oldest, popular
    }
    
    func generateURL() -> URLComponents {
        let client = URLQueryItem(name: "client_id", value: "IxQ_JAE-x1Cx0UuHVg_jXoPWYWi_nGXcjVSyqDXYLhI")
        var url = URLComponents()
        
        url.scheme = "https"
        url.host = "api.unsplash.com"
        url.path = "/photos"
        
        switch self {
        case .main(let page, let perPage, let orderBy):
            let page = URLQueryItem(name: "page", value: "\(page)")
            let perPage = URLQueryItem(name: "per_page", value: "\(perPage)")
            let orderBy = URLQueryItem(name: "order_by", value: "\(orderBy.rawValue)")
            
            url.queryItems = [client, page, perPage, orderBy]
        case .id(let id):
            url.path.append("/\(id)")
            url.queryItems = [client]
        case .random(let count):
            let count = URLQueryItem(name: "count", value: "\(count)")
            
            url.path.append("/random")
            url.queryItems = [client, count]
        }
        
        return url
    }
}

struct EndPoint {
    var scheme = "https"
    var baseURL: String
    var path: String
    var queryItems: [URLQueryItem]
    var method: HttpMethod = .get
    
    func generateURL() -> URLComponents {
        var resultUrlComponents = URLComponents()
        
        resultUrlComponents.scheme = scheme
        resultUrlComponents.host = baseURL
        resultUrlComponents.path = path
        resultUrlComponents.queryItems = queryItems
        
        return resultUrlComponents
    }
    
    func addQueryItem(_ name: String, value: String) {
        
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
