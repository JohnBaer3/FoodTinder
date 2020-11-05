//
//  LikedFoodsViewTVC.swift
//  FoodTinder
//
//  Created by John Baer on 11/3/20.
//

import UIKit

class LikedFoodsTVC: UITableViewCell {

    @IBOutlet weak var restaurantTitleLabel: UILabel!
    
    var restaurantImageView = UIImageView()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(restaurantImageView)
        configureRestaurantTitle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureRestaurantTitle(){
        //If font size is too big for the space, shrink it a little bit
        restaurantTitleLabel.numberOfLines = 0
        restaurantTitleLabel.adjustsFontSizeToFitWidth = true
    }

}
