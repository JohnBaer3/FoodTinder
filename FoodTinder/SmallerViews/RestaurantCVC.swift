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
    func didTapSuperLike(with model: RestaurantListViewModel)
    func didTapList()
}


class RestaurantCVC: UICollectionViewCell {
    weak var restaurantCellDelegate: RestaurantCollectionViewCellDelegate?
    private var restaurantModel: RestaurantListViewModel?
    
    static let identifier = "RestaurantCell"
    var clickedLike = false
    var clickedSuperLike = false
    
    private let restaurantImage: UIImageView = {
        let restaurantImage = UIImageView()
        return restaurantImage
    }()
    
    private let restaurantLabel: UILabel = {
        let restaurantLabel = UILabel()
        restaurantLabel.textAlignment = .left
        restaurantLabel.textColor = .white
        restaurantLabel.font = .boldSystemFont(ofSize: 30.0)
        restaurantLabel.backgroundColor = .black
        return restaurantLabel
    }()
    
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        let image = UIImage(imageLiteralResourceName: "heartUnfilled")
        likeButton.setBackgroundImage(image, for: .normal)
        return likeButton
    }()
    
    private let superLikeButton: UIButton = {
        let superLikeButton = UIButton()
        let image = UIImage(imageLiteralResourceName: "superLikeUnfilled")
        superLikeButton.setBackgroundImage(image, for: .normal)
        return superLikeButton
    }()
    
    private let listButton: UIButton = {
        let listButton = UIButton()
        let image = UIImage(imageLiteralResourceName: "notePad")
        listButton.setBackgroundImage(image, for: .normal)
        return listButton
    }()
    
    private let arrowButton: UIButton = {
        let arrowButton = UIButton()
        let image = UIImage(imageLiteralResourceName: "sidewaysArrow")
        arrowButton.setBackgroundImage(image, for: .normal)
        return arrowButton
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.backgroundColor = .black
        contentView.clipsToBounds = true
    }
    
    
    public func configure(with model: RestaurantListViewModel){
        self.restaurantModel = model
        
        restaurantImage.af.setImage(withURL: restaurantModel!.imageUrl)
        let (imageWidth, imageHeight) = getURLImageSize(url: restaurantModel!.imageUrl as CFURL)
        let imageWidthRatio = imageWidth/contentView.frame.size.width
        let imageHeightRatio = imageHeight/contentView.frame.size.height
        let imageRatio = imageWidthRatio > imageHeightRatio ? 1/imageWidthRatio : 1/imageHeightRatio
        restaurantImage.frame = CGRect(x: (contentView.frame.size.width-imageWidth*imageRatio)/2,
                                       y: (contentView.frame.size.height-imageHeight*imageRatio)/2,
                                       width: imageWidth*imageRatio,
                                       height: imageHeight*imageRatio
                                )
        
        restaurantLabel.text = restaurantModel!.name
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchDown)
        superLikeButton.addTarget(self, action: #selector(superLikeButtonClicked), for: .touchDown)
        listButton.addTarget(self, action: #selector(listButtonClicked), for: .touchDown)
        
        layoutSubviews()
        
        contentView.addSubview(restaurantImage)
        contentView.addSubview(restaurantLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(superLikeButton)
        contentView.addSubview(listButton)
        contentView.addSubview(arrowButton)
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
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        let size = 50
        let width = contentView.frame.size.width - 30
        let height = contentView.frame.size.height
        
        restaurantLabel.frame = CGRect(x: 50, y: 0, width: restaurantModel!.name.width(withConstrainedHeight: 20, font: UIFont(name: "Helvetica Neue", size: 35)!) + 10, height: 80)
        arrowButton.frame = CGRect(x: 30, y: Int(contentView.frame.size.height)/2-13, width: size-25, height: size-15)
        
        likeButton.frame = CGRect(x: Int(width)-size-20, y: Int(contentView.frame.size.height)/2, width: size+10, height: size-10)
        superLikeButton.frame = CGRect(x: Int(width)-size-15, y: Int(contentView.frame.size.height)/2+size+10, width: size-5, height: size-10)
        listButton.frame = CGRect(x: Int(width)-size-10, y: Int(contentView.frame.size.height)/2+size*2+20, width: size-15, height: size)

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
        restaurantCellDelegate?.didTapLike(with: restaurantModel)
        
        clickedLike = !clickedLike
        if clickedLike{
            let systemImage = UIImage(imageLiteralResourceName: "heartFilled")
            likeButton.setBackgroundImage(systemImage, for: .normal)
        }else{
            let systemImage = UIImage(imageLiteralResourceName: "heartUnfilled")
            likeButton.setBackgroundImage(systemImage, for: .normal)
        }
    }
    

    @objc private func superLikeButtonClicked(){
        guard let restaurantModel = restaurantModel else { return }
        restaurantCellDelegate?.didTapSuperLike(with: restaurantModel)
        
        clickedSuperLike = !clickedSuperLike
        if clickedSuperLike{
            let systemImage = UIImage(imageLiteralResourceName: "superLikeFilled")
            superLikeButton.setBackgroundImage(systemImage, for: .normal)
        }else{
            let systemImage = UIImage(imageLiteralResourceName: "superLikeUnfilled")
            superLikeButton.setBackgroundImage(systemImage, for: .normal)
        }
    }
    
    
    @objc private func listButtonClicked(){
        restaurantCellDelegate?.didTapList()
    }
    
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> Int {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return Int(ceil(boundingBox.height))
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> Int {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return Int(ceil(boundingBox.width))
    }
}
