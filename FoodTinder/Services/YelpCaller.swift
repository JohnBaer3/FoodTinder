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
    var lat: Double = 40.7128
    var long: Double = -122.0230
    
    func yelpCall(parameters: [(filterType: filterTypes, content: Any)], completion: @escaping (Result<[RestaurantListViewModel], Error>) -> Void){
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        for parameter in parameters{
            switch parameter.filterType{
            case .radius:
                radius = Int(parameter.content as! String)!
            case .foods:
                foodTerm = parameter.content as! String
            case .location:
                let arr = parameter.content as! [Double]
                lat = arr[0]
                long = arr[1]
            case .price:
                price = parameter.content as! String
            case .categories:
                let categoryArray = parameter.content as! [String]
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
