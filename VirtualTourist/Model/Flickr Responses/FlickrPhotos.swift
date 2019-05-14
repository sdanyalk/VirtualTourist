//
//  FlickrPhotos.swift
//  VirtualTourist
//
//  Created by SDK on 5/13/19.
//  Copyright © 2019 SDK. All rights reserved.
//

import Foundation

struct FlickrPhotos: Codable {
    
    let page: Int
    let pages: String
    let perpage: String
    let total: String
    let photo: [FlickrPhoto]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case total
        case photo
    }
}
