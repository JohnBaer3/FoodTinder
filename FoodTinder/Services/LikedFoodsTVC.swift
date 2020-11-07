//
//  LikedFoodsViewTVC.swift
//  FoodTinder
//
//  Created by John Baer on 11/3/20.
//

import UIKit

class LikedFoodsTVC: UITableViewCell {

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantTitleLabel: UILabel!
    @IBOutlet weak var restaurantDistanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var likedOrSuperButton: UIButton!
    
    var imageURL: URL? = nil{
        didSet{
            print("hmm")
            configureRestaurantImage()
        }
    }
    
    @IBAction func likedOrSuperButtonClicked(_ sender: Any) {
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureRestaurantTitle()
        configureRestaurantImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureRestaurantTitle(){
        //If font size is too big for the space, shrink it a little bit
        restaurantTitleLabel.numberOfLines = 0
        restaurantTitleLabel.adjustsFontSizeToFitWidth = true
        restaurantTitleLabel.textColor = .white
    }
    
    func configureRestaurantImage(){
        restaurantImageView.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
    }

    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            let newWidth = frame.width
            frame.size.width = newWidth
            frame.size.height = 200
            super.frame = frame
        }
    }
}
