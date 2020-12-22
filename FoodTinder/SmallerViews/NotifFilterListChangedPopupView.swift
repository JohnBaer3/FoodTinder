//
//  NotifFilterListChangedPopupView.swift
//  FoodTinder
//
//  Created by John Baer on 11/8/20.
//

import UIKit

class NotifFilterListChangedPopupView: UIView {
   
    static let identifier = "NotifFilterListChangedPopupView"

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.text = "New filters added!"
        titleLabel.backgroundColor = .darkGray
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 15
        return titleLabel
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    
    public func configure(){
        layoutSubviews()
        self.addSubview(titleLabel)
    }
    
    override func layoutSubviews(){
        titleLabel.frame = CGRect(x: -1*sizeOfText(titleLabel.text!, 20), y: 0, width: sizeOfText(titleLabel.text!, 20)+30, height: 30)

    }
    
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
    }
    
    func sizeOfText(_ titleText: String, _ sizeOfFont: CGFloat) -> Int{
        return titleText.width(withConstrainedHeight: 40, font: UIFont(name: "Helvetica Neue", size: sizeOfFont)!)
    }
}
