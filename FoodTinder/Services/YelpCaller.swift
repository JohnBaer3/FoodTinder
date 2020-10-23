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
    var restaurants: [RestaurantListViewModel]? = nil
    
    func yelpCall(completion: @escaping (Result<[RestaurantListViewModel], Error>) -> Void){
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        service.request(.search(lat: 37.2638, long: -122.0230)){ (result) in
            switch result{
            case .success(let response):
                let root = try? self.jsonDecoder.decode(Root.self, from: response.data)
                completion(.success((root?.businesses.compactMap(RestaurantListViewModel.init))!))
            case .failure(_):
                print("error")
            }
        }
    }
}
