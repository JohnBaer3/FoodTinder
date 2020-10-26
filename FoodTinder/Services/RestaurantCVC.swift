//
//  RestaurantCVC.swift
//  FoodTinder
//
//  Created by John Baer on 10/23/20.
//

import UIKit
import AlamofireImage


protocol RestaurantCollectionViewCellDelegate: AnyObject{
    func didTapLike(with model: RestaurantListViewModel)
}


class RestaurantCVC: UICollectionViewCell {
    weak var delegate: RestaurantCollectionViewCellDelegate?
    private var restaurantModel: RestaurantListViewModel?
    
    static let identifier = "RestaurantCell"

    
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
    
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setBackgroundImage(UIImage(systemName: "heart.circle"), for: .normal)
        return likeButton
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.backgroundColor = .black
        contentView.clipsToBounds = true
    }
    
    
    public func configure(with model: RestaurantListViewModel){
        self.restaurantModel = model
        
        restaurantImage.af.setImage(withURL: restaurantModel!.imageUrl)
        restaurantLabel.text = restaurantModel!.name
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchDown)

        layoutSubviews()
        
        contentView.addSubview(restaurantImage)
        contentView.addSubview(restaurantLabel)
        contentView.addSubview(likeButton)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        let size = contentView.frame.size.width/6
        let width = contentView.frame.size.width
        let height = contentView.frame.size.height
        
        restaurantLabel.frame = CGRect(x: width-size, y: height-size, width: size, height: size)
        likeButton.frame = CGRect(x: width-size, y: height-size+50, width: size, height: size)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantLabel.text = nil
        restaurantImage.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("Oops! RestaurantCVC error")
    }
    
    
    @objc private func likeButtonClicked(){
        guard let restaurantModel = restaurantModel else { return }
        delegate?.didTapLike(with: restaurantModel)
        print("yaas")
    }
    
}
