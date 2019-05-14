//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by SDK on 5/13/19.
//  Copyright © 2019 SDK. All rights reserved.
//

import Foundation

class FlickrClient {
    
    class func getPhotos(lat: Double, long: Double, completion: @escaping (PhotoResponse?, Error?) -> Void) {
        let urlQueryParams = "&lat=" + String(lat) + "&lon=" + String(long) + "&format=json&nojsoncallback=1"
        let userInfoUrl: URL = URL(string: Endpoints.searchPhotos.stringValue + urlQueryParams)!
        
        taskForGETRequest(url: userInfoUrl, responseType: PhotoResponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL,
                                                          responseType: ResponseType.Type,
                                                          completion: @escaping (ResponseType?, Error?) -> Void) -> Void {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            let newData = data.subdata(in: 5..<data.count)
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
}
