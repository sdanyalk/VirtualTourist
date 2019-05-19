//
//  Endpoints.swift
//  VirtualTourist
//
//  Created by SDK on 5/13/19.
//  Copyright © 2019 SDK. All rights reserved.
//

import Foundation

enum Endpoints {
    
    static let flickrBaseUrl = "https://api.flickr.com/services/rest"
    static let key = "c7a935b0949bc309070585da991bc8c4"
    static let secret = "61f7e472aca8e60b"
    
    case searchPhotos
    
    var stringValue: String {
        switch self {
        case .searchPhotos:
            return Endpoints.flickrBaseUrl + "/?method=flickr.photos.search&api_key=" + Endpoints.key
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
