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
    
    var radius: Double = 20000
    var foodTerm: String = ""
    var categories: String = ""
    var price: Int = 1
    var lat: Double = 40.7128
    var long: Double = -122.0230
    
    func yelpCall(parameters: [(filterType: filterTypes, content: Any)], completion: @escaping (Result<[RestaurantListViewModel], Error>) -> Void){
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let cleanedInput = cleanFilterInput(parameters)
        
        for parameter in cleanedInput{
            switch parameter.filterType{
            case .radius:
                radius = parameter.content as! Double
            case .foods:
                foodTerm = parameter.content as! String
            case .location:
                let coordinate = parameter.content as! (Double, Double)
                lat = coordinate.0
                long = coordinate.1
            case .price:
                price = parameter.content as! Int
            case .categories:
                categories = parameter.content as! String
            }
        }
        
        //Probably needs to be put into another thread
        service.request(.search(term: foodTerm, lat: lat, long: long, categories: categories)){ (result) in
            switch result{
                case .success(let response):
                    let root = try? self.jsonDecoder.decode(Root.self, from: response.data)
                    //Handle this when it returns nil
                    
                    
                    completion(.success((root?.businesses.compactMap(RestaurantListViewModel.init))!))
                case .failure(_):
                    print("error")
            }
        }
    }
    
    
    
    
    func cleanFilterInput(_ filters: [(filterType: filterTypes, content: Any)]) ->  [(filterType: filterTypes, content: Any)]{
        var cleanedFilter: [(filterType: filterTypes, content: Any)] = []
        //For price, convert $=1, $=2, etc
        //For categories, change whole string to lowercase
        //For radius, convert miles to meters
        //For location, convert a lot of different string to point coordinates
        //For foods just convert to lowercase
        var categoriesString = ""
        for filter in filters{
            switch filter.filterType{
            case .price:
                let priceLength = (filter.content as! String).count
                cleanedFilter.append((filterType: .price, content: priceLength))
            case .categories:
                categoriesString += undercaseAndRemoveSpaces(filter.content as! String)
                categoriesString += ","
            case .radius:
                //0-5 mi, 5-10, 10-15, 15-20, 20-25+
                var metersConversion = 1609.34
                switch filter.content as! String{
                case "0-5 mi":
                    metersConversion*=5
                case "5-10 mi":
                    metersConversion*=10
                case "10-15 mi":
                    metersConversion*=15
                case "15-20 mi":
                    metersConversion*=20
                case "20-25+ mi":
                    metersConversion=40000
                default:
                    metersConversion=10000
                }
                cleanedFilter.append((filterType: .radius, content: metersConversion))
            case .location:
                var location: (Double, Double) = (0, 0)
                if filter.content is String{
                    location = getLocationCoordinates((filter.content as! String))
                }else{
                    location = filter.content as! (Double, Double)
                }
                cleanedFilter.append((filterType: .location, content: location))
            case .foods:
                cleanedFilter.append((filterType: .foods, content: (filter.content as! String).lowercased()))
            default:
                print(filter.filterType)
            }
        }
        categoriesString = categoriesString.lowercased()
        categoriesString = String(categoriesString.dropLast())
        cleanedFilter.append((filterType: .categories, content: categoriesString))
        
//        print("cleaned: ", cleanedFilter)
        
        return cleanedFilter
    }
    
    func undercaseAndRemoveSpaces(_ category: String) -> String{
        var result = category
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)
        result = result.lowercased()
        return result
    }

    func getLocationCoordinates(_ location: String) -> (Double, Double){
        var locationCord: (Double, Double) = (0, 0)
        switch location{
        case "LA":
            locationCord = (34.0522, -118.2437)
        case "New York":
            locationCord = (40.7128, -74.0060)
        case "Tokyo":
            locationCord = (35.6762, 139.6503)
        case "Taiwan":
            locationCord = (23.6978, 120.9605)
        case "Cincinnati":
            locationCord = (39.1031, -84.5120)
        case "Texas":
            locationCord = (31.9686, -99.9018)
        case "Grand Rapids":
            locationCord = (42.9634, -85.6681)
        case "Honolulu":
            locationCord = (21.3069, -157.8583)
        case "Miami":
            locationCord = (25.7617, -80.1918)
        case "Seattle":
            locationCord = (47.6062, -122.3321)
        case "San Francisco":
            locationCord = (37.7749, -122.4194)
        case "Las Vegas":
            locationCord = (36.1699, -115.1398)
        case "Chicago":
            locationCord = (41.8781, -87.6298)
        case "Tampa":
            locationCord = (27.9506, -82.4572)
        case "Florence":
            locationCord = (43.7696, 11.2558)
        case "Rome":
            locationCord = (41.9028, 12.4964)
        case "Kyoto":
            locationCord = (35.0116, 135.7681)
        case "Singapore":
            locationCord = (1.3521, 103.8198)
        case "Paris":
            locationCord = (48.8566, 2.3522)
        default:
            locationCord = parseLocationCord(location)
        }
        return locationCord
    }
    
    
    func parseLocationCord(_ locationsCoords: String) -> (Double, Double){
        let index = locationsCoords.firstIndex(of: ",")!
        let latitude = String(locationsCoords[..<index])
        let nextIndex = locationsCoords.index(after: index)
        let longitude = String(locationsCoords[nextIndex...])
        return (Double(latitude)!, Double(longitude)!)
    }
}
