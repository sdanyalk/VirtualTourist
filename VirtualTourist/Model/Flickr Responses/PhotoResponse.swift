//
//  PhotoResponse.swift
//  VirtualTourist
//
//  Created by SDK on 5/13/19.
//  Copyright © 2019 SDK. All rights reserved.
//

import Foundation

struct PhotoResponse: Codable {
    let name: String
    let stat: String
    
    enum CodingKeys: String, CodingKey {
        case name = "nickname"
        case stat = "stat"
    }
}
