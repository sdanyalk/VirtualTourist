//
//  PhotoResponse.swift
//  VirtualTourist
//
//  Created by SDK on 5/13/19.
//  Copyright © 2019 SDK. All rights reserved.
//

import Foundation

struct PhotoResponse: Codable {
    let photos: FlickrPhotos
    let stat: String
    
    enum CodingKeys: String, CodingKey {
        case photos
        case stat
    }
}
