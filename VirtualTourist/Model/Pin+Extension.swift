//
//  Pin+Extension.swift
//  VirtualTourist
//
//  Created by SDK on 5/15/19.
//  Copyright © 2019 SDK. All rights reserved.
//

import Foundation
import MapKit

extension Pin: MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitude)
        
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
