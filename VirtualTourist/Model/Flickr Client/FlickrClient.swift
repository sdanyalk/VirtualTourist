//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by SDK on 5/13/19.
//  Copyright © 2019 SDK. All rights reserved.
//

import Foundation

class FlickrClient {
    
    class func getPhotos(lat: Double, long: Double, completion: @escaping ([String]?, Error?) -> Void) {
        let urlQueryParams = "&lat=" + String(lat) + "&lon=" + String(long) + "&format=json&nojsoncallback=1&page=1"
        let userInfoUrl: URL = URL(string: Endpoints.searchPhotos.stringValue + urlQueryParams)!
        
        taskForGETRequest(url: userInfoUrl, responseType: PhotoResponse.self) { response, error in
            if let response = response {
                let photoURLlist: [String] = parsePhotoUrl(flickrPhotos: response.photos.photo)
                
                completion(photoURLlist, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getPhotoImage(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        taskForGETRequest(url: url) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func taskForGETRequest(url: URL, completion: @escaping (Data?, Error?) -> Void) -> Void {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        
        task.resume()
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
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
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

extension FlickrClient {
    
    private class func parsePhotoUrl (flickrPhotos: [FlickrPhoto]) -> [String] {
        var photoURLs: [String] = []
        
        for photo in flickrPhotos {
            let photoURL = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
            
            photoURLs.append(photoURL)
        }
        
        return photoURLs
    }
}
