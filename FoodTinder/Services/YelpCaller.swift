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

//Filter by - a Radius, Foods (term), Price, Location filters

class YelpCaller{
    
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    let jsonDecoder = JSONDecoder()
    let appD = AppDelegate()
    var restaurants: [RestaurantListViewModel]? = nil
    
    var radius: Int = 20000
    var foodTerm: String = ""
    var price: String = ""
    var lat: Double = 37.2638
    var long: Double = -122.0230
    
    func yelpCall(parameters: [(filterType: filterTypes, title: String)], completion: @escaping (Result<[RestaurantListViewModel], Error>) -> Void){
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        for parameter in parameters{
            switch parameter.filterType{
            case .radius:
                radius = Int(parameter.title)!
            case .foods:
                foodTerm = parameter.title
            case .location:
                lat = Double(parameter.title)!
                long = Double(parameter.title)!
            case .price:
                price = parameter.title
            }
        }
        
        service.request(.search(term: foodTerm, lat: lat, long: long)){ (result) in
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
