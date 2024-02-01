//
//  ImageDataDTO.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/1/24.
//

import Foundation

struct MainImageDataDTO: Decodable {
    let id: String
    let width: Int
    let height: Int
    let description: String?
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case id
        case width, height
        case description
        case urls
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    let smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw
        case full
        case regular
        case small
        case thumb
        case smallS3 = "small_s3"
    }
}
// MARK: - Links
struct Links: Codable {
    let linksSelf: String
    let html: String
    let download: String
    let downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html
        case download
        case downloadLocation = "download_location"
    }
}
