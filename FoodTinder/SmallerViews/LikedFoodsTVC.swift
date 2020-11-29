//
//  LikedFoodsViewTVC.swift
//  FoodTinder
//
//  Created by John Baer on 11/3/20.
//

import UIKit
import AlamofireImage

class LikedFoodsTVC: UITableViewCell {
    static let identifier = "LikedFoodsTVC"

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantTitleLabel: UILabel!
    @IBOutlet weak var restaurantDistanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var likedOrSuperButton: UIButton!
    
    var imageURL: URL? = nil
    
    @IBAction func likedOrSuperButtonClicked(_ sender: Any) {
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureRestaurantTitle()
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
    
    func configure(_ cellInfo: SuperOrLikedRestaurants){   
        restaurantTitleLabel.text = cellInfo.restaurantName
        imageURL = cellInfo.restaurantPic
        restaurantImageView.af.setImage(withURL: cellInfo.restaurantPic)

        let (imageWidth, imageHeight) = getURLImageSize(url: (imageURL! as CFURL))
        let imageRatio = resizeImage(imageWidth, imageHeight)
        restaurantImageView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: imageWidth*imageRatio,
                                       height: imageHeight*imageRatio
                                )
        restaurantImageView.frame = CGRect(x: (contentView.frame.size.width-imageWidth*imageRatio)/2,
                                       y: (contentView.frame.size.height-imageHeight*imageRatio)/2,
                                       width: imageWidth*imageRatio,
                                       height: imageHeight*imageRatio
                                )
    }
    
    func resizeImage(_ imageWidth: CGFloat, _ imageHeight: CGFloat) -> CGFloat {
        let imageWidthRatio = imageWidth/100
        let imageHeightRatio = imageHeight/100
//        let imageWidthRatio = imageWidth/contentView.frame.size.width
//        let imageHeightRatio = imageHeight/contentView.frame.size.height
        let imageRatio = imageWidthRatio > imageHeightRatio ? 1/imageWidthRatio : 1/imageHeightRatio
        return imageRatio
    }
    
    
    func configureRestaurantTitle(){
        //If font size is too big for the space, shrink it a little bit
        restaurantTitleLabel.numberOfLines = 0
        restaurantTitleLabel.adjustsFontSizeToFitWidth = true
        restaurantTitleLabel.textColor = .white
    }
    
    
    func getURLImageSize(url: CFURL) -> (CGFloat, CGFloat){
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! CGFloat
                let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! CGFloat
                return (pixelWidth, pixelHeight)
            }
        }
        //Default if image size can't be found
        return (300, 300)
    }
}
