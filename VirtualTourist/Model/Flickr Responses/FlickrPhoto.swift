//
//  Photo.swift
//  VirtualTourist
//
//  Created by SDK on 5/13/19.
//  Copyright © 2019 SDK. All rights reserved.
//

import Foundation

struct FlickrPhoto: Codable {

    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPublic: Bool
    let isFriend: Bool
    let isFamily: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
}
