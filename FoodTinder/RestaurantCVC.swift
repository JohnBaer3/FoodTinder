//
//  RestaurantCVC.swift
//  FoodTinder
//
//  Created by John Baer on 10/23/20.
//

import UIKit
import AlamofireImage


class RestaurantCVC: UICollectionViewCell {
    static let identifier = "RestaurantCell"
    private var restaurantModel: RestaurantListViewModel?
    
    
    private let restaurantImage: UIImageView = {
        let restaurantImage = UIImageView()
        return restaurantImage
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.backgroundColor = .orange
        contentView.clipsToBounds = true
    }
    
    public func configure(with model: RestaurantListViewModel){
        self.restaurantModel = model
        
        restaurantImage.af_setImage(withURL: restaurantModel!.imageUrl)
        contentView.addSubview(restaurantImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Oops! RestaurantCVC error")
    }
    
}
