//
//  SuperAndLikedRestaurants.swift
//  FoodTinder
//
//  Created by John Baer on 11/4/20.
//

import Foundation

class SuperOrLikedRestaurants{
    let restaurantName: String
    let restaurantPic: URL
    let restaurantLatitude: Float
    let restaurantLongitude: Float
    let restaurantRating: Float
    let restaurantSuperLiked: Bool
    let restaurantYelpURL: String
    
    init(restaurantName: String,
         restaurantPic: URL,
         restaurantLatitude: Float,
         restaurantLongitude: Float,
         restaurantRating: Float,
         restaurantSuperLiked: Bool,
         restaurantYelpURL: String
    ){
        self.restaurantName = restaurantName
        self.restaurantPic = restaurantPic
        self.restaurantLatitude = restaurantLatitude
        self.restaurantLongitude = restaurantLongitude
        self.restaurantRating = restaurantRating
        self.restaurantSuperLiked = restaurantSuperLiked
        self.restaurantYelpURL = restaurantYelpURL
    }
    
}
