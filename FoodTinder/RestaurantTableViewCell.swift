//
//  RestaurantTableViewCell.swift
//  FoodTinder
//
//  Created by John Baer on 10/17/20.
//

import UIKit
import AlamofireImage


class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantDistance: UILabel!
    @IBOutlet weak var restaurantPicTitle: UILabel!
    
    
    func configure(with viewModel: RestaurantListViewModel){
        restaurantImage.af_setImage(withURL: viewModel.imageUrl)
        restaurantName.text = viewModel.name
        restaurantDistance.text = viewModel.distance
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
