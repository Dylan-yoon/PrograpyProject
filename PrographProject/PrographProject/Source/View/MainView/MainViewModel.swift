//
//  MainViewModel.swift
//  PrographProject
//
//  Created by Dylan_Y on 1/30/24.
//

import Foundation

final class MainViewModel {
    var bookmarkData = BookMarkData.generateMockDatas()
    var recentData = MockData.generateMockDatas()
}

struct BookMarkData {
    var imageName: String
    
    static func generateMockDatas() -> [Self] {
        var mockData = [BookMarkData]()
        
        mockData.append(BookMarkData(imageName: "praha"))
        mockData.append(BookMarkData(imageName: "thumbnail"))
        mockData.append(BookMarkData(imageName: "thumbnail-2"))
        mockData.append(BookMarkData(imageName: "thumbnail-3"))
        
        return mockData
    }
}

struct MockData: Hashable {
    var isBookMarked = false
    var imageName: String
    var title: String
    var identifier = UUID()
    
    static func generateMockDatas() -> [Self] {
        var mockData = [MockData]()
        
        mockData.append(MockData(isBookMarked: false, imageName: "praha", title: "프라하 \n 여기는 프라하"))
        mockData.append(MockData(isBookMarked: false, imageName: "thumbnail", title: "첫 번 째  \n 이미지"))
        mockData.append(MockData(isBookMarked: false, imageName: "thumbnail-2", title: "세 번 째 \n 이미지이"))
        mockData.append(MockData(isBookMarked: false, imageName: "thumbnail-3", title: "세 번 째 \n 이미지이이이"))
        
        return mockData
    }
}
