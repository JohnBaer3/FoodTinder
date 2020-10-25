//
//  NetworkService.swift
//  FoodTinder
//
//  Created by John Baer on 10/15/20.
//

import Foundation
import Moya

private let apiKey = "MQ6jHBWvkx6tVbk3hoirag0wr5DdOo9isHsO13PbQMGZ-AHpJu1lsndai4S6DxElgvd9PGXXM0vA3bRpQDtRuos4PTTmAwZFS60YT8eZWiurmAr368X_B8fvaKp-X3Yx"

enum YelpService{
    enum BusinessesProvider: TargetType{
        case search(term: String, lat: Double, long: Double)
        
        var baseURL: URL{
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String{
            switch self{
            case .search:
            return "/search"
            }
        }
        
        var method: Moya.Method{
            return .get
        }
        
        var sampleData: Data{
            return Data()
        }
        
        var task: Task{
            switch self{
            case let .search(term, lat, long):
                return .requestParameters(parameters: ["term": term, "latitude": lat, "longitude": long, "limit": 10], encoding: URLEncoding.queryString)
            }
        }
        
        var headers: [String: String]?{
            return ["Authorization": "Bearer \(apiKey)"]
        }
    }
}
