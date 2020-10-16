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
    let distance: Double
}

struct RestaurantListViewModel{
    let name: String
    let imageUrl: URL
    let distance: String
    let id: String
}

extension RestaurantListViewModel{
    init(business: Business){
        self.name = business.name
        self.id = business.id
        self.imageUrl = business.imageUrl
        self.distance = "\(business.distance / 1609.344)"
    }
}
