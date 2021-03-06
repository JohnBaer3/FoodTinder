//
//  FilterLabelTitle.swift
//  FoodTinder
//
//  Created by John Baer on 10/27/20.
//

import UIKit


class FilterTitleLabel: UILabel {
    var title: String?
    var contentViewWidth: CGFloat = 800
    var yPos: Int = 0
    
    required init(title: String, contentViewWidth: CGFloat, yPos: Int) {
        super.init(frame: .zero)
        self.title = title
        self.contentViewWidth = contentViewWidth
        self.yPos = yPos
        setUpLabel()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    func setUpLabel(){
        textAlignment = .left
        textColor = .white
        font = .boldSystemFont(ofSize: 35.0)
        frame = CGRect(x: Int(contentViewWidth/9), y: yPos, width: title!.width(withConstrainedHeight: 20, font: UIFont(name: "Helvetica Neue", size: 35)!), height: 50)
        self.text = title
    }
    
}
