//
//  ImageData.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/3/24.
//

import UIKit

struct ImageData: Hashable {
    let id: String
    let description: String?
    let urlString: String?
    let uiimage: UIImage?
    let userName: String?
    
    static func defaultData() -> Self {
        ImageData(id: "USER NAME",
                  description: "NOT DESCRIPTION",
                  urlString: "NO URL",
                  uiimage: UIImage(systemName: "questionmark.circle"),
                  userName: "NO NAME")
    }
}
