//
//  FilterLabelTitle.swift
//  FoodTinder
//
//  Created by John Baer on 10/27/20.
//

import UIKit


class FilterTitleLabel: UILabel {
    var title: String?
    
    required init(title: String) {
        super.init(frame: .zero)
        self.title = title
        setUpLabel()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    func setUpLabel(){
        textAlignment = .left
        textColor = .white
        font = .boldSystemFont(ofSize: 30.0)
        frame = CGRect(x: 30, y: 100, width: title!.width(withConstrainedHeight: 20, font: UIFont(name: "Helvetica Neue", size: 35)!), height: 50)
        self.text = title
    }
    
}
