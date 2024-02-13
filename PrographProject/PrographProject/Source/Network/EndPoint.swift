//
//  EndPoint.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/2/24.
//

import Foundation

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
}
