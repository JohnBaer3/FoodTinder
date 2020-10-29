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
    var categories: String = ""
    var price: String = ""
    var lat: Double = 37.2638
    var long: Double = -122.0230
    
    func yelpCall(parameters: [(filterType: filterTypes, title: Any)], completion: @escaping (Result<[RestaurantListViewModel], Error>) -> Void){
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        for parameter in parameters{
            switch parameter.filterType{
            case .radius:
                radius = Int(parameter.title as! String)!
            case .foods:
                foodTerm = parameter.title as! String
            case .location:
                lat = Double(parameter.title as! String)!
                long = Double(parameter.title as! String)!
            case .price:
                price = parameter.title as! String
            case .categories:
                let categoryArray = parameter.title as! [String]
                categories = ""
                for category in categoryArray{
                    categories += category
                    categories += ","
                }
            }
        }
        
        //Probably needs to be put into another thread
        service.request(.search(term: foodTerm, lat: lat, long: long, categories: categories)){ (result) in
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
