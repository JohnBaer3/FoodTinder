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
    @IBOutlet weak var restaurantRatingLabel: UILabel!
    @IBOutlet weak var likedOrSuperButton: UIButton!
    
    var imageURL: URL? = nil
    var currentLat: Double? = nil
    var currentLong: Double? = nil
    
    @IBAction func likedOrSuperButtonClicked(_ sender: Any) {
        
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .black
    }
    
    func configure(_ cellInfo: SuperOrLikedRestaurants, _ currentLatt: Double, _ currentLongg: Double){
        imageURL = cellInfo.restaurantPic
        currentLat = currentLatt
        currentLong = currentLongg
        
        restaurantImageView.af.setImage(withURL: cellInfo.restaurantPic)
        restaurantTitleLabel.text = cellInfo.restaurantName
        restaurantDistanceLabel.text = findDistance(Double(cellInfo.restaurantLatitude), Double(cellInfo.restaurantLongitude))
        restaurantRatingLabel.text = String(cellInfo.restaurantRating) + "/5"
        
        configureRestaurantImage()
        configureTexts()
        configureSelectButton()
    }
    
    
    
    func configureRestaurantImage(){
        let (imageWidth, imageHeight) = getURLImageSize(url: (imageURL! as CFURL))
        let imageRatio = resizeImage(imageWidth, imageHeight)
        restaurantImageView.frame = CGRect(x: 70, y: 30, width: imageWidth*imageRatio, height: imageHeight*imageRatio)
    }
    
    func resizeImage(_ imageWidth: CGFloat, _ imageHeight: CGFloat) -> CGFloat {
        let imageWidthRatio = imageWidth/contentView.frame.size.width
        let imageHeightRatio = imageHeight/contentView.frame.size.height
        let imageRatio = imageWidthRatio > imageHeightRatio ? 1/imageWidthRatio : 1/imageHeightRatio
        return imageRatio
    }
    
    
    func configureTexts(){
        //If font size is too big for the space, shrink it a little bit
        restaurantTitleLabel.frame = CGRect(x: 220, y: 0, width: restaurantTitleLabel.text!.width(withConstrainedHeight: 20, font: UIFont(name: "Helvetica Neue", size: 40)!) + 80, height: 80)
        restaurantDistanceLabel.frame = CGRect(x: 220, y: 40, width: restaurantDistanceLabel.text!.width(withConstrainedHeight: 20, font: UIFont(name: "Helvetica Neue", size: 30)!) + 10, height: 80)
        restaurantRatingLabel.frame = CGRect(x: 220, y: 70, width: restaurantRatingLabel.text!.width(withConstrainedHeight: 20, font: UIFont(name: "Helvetica Neue", size: 30)!) + 10, height: 80)
    }
    
    
    func configureSelectButton(){
        likedOrSuperButton.frame = CGRect(x: self.frame.width-50, y: 40, width: 40, height: 40)
    }
    
    func findDistance(_ latitude: Double, _ longitude: Double) -> String{
        let latDiff = abs(currentLat! - latitude)
        let longDiff = abs(currentLong! - longitude)
        let diff = sqrt(pow(latDiff, 2) + pow(longDiff, 2))
        //1 degree = 69 miles. Also, the 1000s multiplication is to get a clean 3 digits for the Double
        let diffConversion = Double(round(1000*diff)/1000) * 69
        return String(diffConversion) + "miles away"
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
