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
        restaurantImage.frame = CGRect(x:0, y:0, width:300, height:300)
        return restaurantImage
    }()
    
    private let restaurantLabel: UILabel = {
        let restaurantLabel = UILabel()
        restaurantLabel.textAlignment = .left
        restaurantLabel.textColor = .white
        return restaurantLabel
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.backgroundColor = .orange
        contentView.clipsToBounds = true
    }
    
    public func configure(with model: RestaurantListViewModel){
        self.restaurantModel = model
        
        restaurantImage.af.setImage(withURL: restaurantModel!.imageUrl)
        restaurantLabel.text = restaurantModel!.name

        layoutSubviews()
        
        contentView.addSubview(restaurantImage)
        contentView.addSubview(restaurantLabel)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        let size = contentView.frame.size.width/6
        let width = contentView.frame.size.width
        let height = contentView.frame.size.height
        
        restaurantLabel.frame = CGRect(x: width-size, y: height-size, width: size, height: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Oops! RestaurantCVC error")
    }
    
}
