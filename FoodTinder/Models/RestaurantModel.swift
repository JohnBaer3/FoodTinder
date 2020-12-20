//
//  RestaurantModel.swift
//  FoodTinder
//
//  Created by John Baer on 10/15/20.
//

import Foundation

struct Root: Codable{
    let businesses: [Business]
}

struct Business: Codable{
    let id: String
    let name: String
    let imageUrl: URL
    let rating: Float
    let distance: Double
    let coordinates: [String: Float]
    let url: String
}

struct RestaurantListViewModel{
    let name: String
    let imageUrl: URL
    let rating: Float
    let distance: String
    let id: String
    let latitude: Float
    let longitude: Float
    let yelpURL: String
}

extension RestaurantListViewModel{
    init(business: Business){
        self.name = business.name
        self.id = business.id
        self.imageUrl = business.imageUrl
        self.rating = business.rating
        self.distance = "\(business.distance / 1609.344)"
        self.latitude = business.coordinates["latitude"] ?? 0.0
        self.longitude = business.coordinates["longitude"] ?? 0.0
        self.yelpURL = business.url
    }
}
