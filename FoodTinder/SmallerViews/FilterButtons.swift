//
//  FilterButtons.swift
//  FoodTinder
//
//  Created by John Baer on 10/25/20.
//

import UIKit

protocol FilterButtonDelegate: AnyObject{
    func didClick(filterType: filterTypes, content: String, buttonDown: Bool)
}

class FilterButtons: UIButton {
    weak var filterButtonDelegate: FilterButtonDelegate!
    var filterType: filterTypes?
    var buttonDown: Bool = false
    var title: String?
    var xPos: Int?
    var yPos: Int?
    
    required init(filterType: filterTypes, title: String, xPos: Int, yPos: Int) {
        super.init(frame: .zero)
        self.filterType = filterType
        self.title = title
        self.xPos = xPos
        self.yPos = yPos
        setTitle(title, for: .normal)
        setUpButton()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setUpButton()
    }
    
    func setUpButton(){
        backgroundColor = #colorLiteral(red: 0.2969530523, green: 0.2969608307, blue: 0.2969566584, alpha: 1)
        setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        layer.cornerRadius = 25.0
        titleLabel?.font =  UIFont(name: "Helvetica Neue", size: 25)
        frame = CGRect(x: xPos!, y: yPos!, width: title!.width(withConstrainedHeight: 25, font: UIFont(name: "Helvetica Neue", size: 30)!)+20, height: 50)
        layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        addTarget(self, action: #selector(buttonClicked), for: .touchDown)
    }
    
    func getWidth() -> Int{
        return Int(self.frame.width)
    }
    
    func buttonSelectHighlightFlip(){
        buttonDown = !buttonDown
        if buttonDown{
            backgroundColor = .white
            setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        }else{
            backgroundColor = #colorLiteral(red: 0.231372549, green: 0.231372549, blue: 0.231372549, alpha: 1)
            setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        }
    }
    
    @objc private func buttonClicked(){
        buttonSelectHighlightFlip()
        filterButtonDelegate?.didClick(filterType: self.filterType!, content: self.currentTitle!, buttonDown: self.buttonDown)
    }
}

