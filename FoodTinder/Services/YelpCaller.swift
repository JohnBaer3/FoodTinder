//
//  YelpCaller.swift
//  FoodTinder
//
//  Created by John Baer on 10/17/20.
//

import Foundation
import Moya
import MapKit
import CoreLocation


class YelpCaller{
    
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    let jsonDecoder = JSONDecoder()
    let appD = AppDelegate()
    
    func yelpCall(){
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        //appD.locVal?.latitude / longitude
        service.request(.search(lat: 37.2638, long: -122.0230)){ (result) in
            switch result{
            case .success(let response):
                let root = try? self.jsonDecoder.decode(Root.self, from: response.data)
                print(root)
            case .failure(let error):
                print("error")
            }
        }
    }
}
