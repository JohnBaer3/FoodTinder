//
//  FilterButtons.swift
//  FoodTinder
//
//  Created by John Baer on 10/25/20.
//

import UIKit

protocol FilterButtonDelegate: AnyObject{
    func didClick(filterType: filterTypes, title: String, buttonDown: Bool)
}


class FilterButtons: UIButton {
    weak var filterButtonDelegate: FilterButtonDelegate!
    var filterType: filterTypes?
    var buttonDown: Bool = false
    
    required init(filterType: filterTypes, title: String) {
        super.init(frame: .zero)
        self.filterType = filterType
        setTitle(title, for: .normal)
        setUpButton()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setUpButton()
    }
    
    func setUpButton(){
        backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        layer.cornerRadius = 20.0
        frame.size = CGSize(width: 100, height: 100)
        addTarget(self, action: #selector(buttonClicked), for: .touchDown)
    }
    
    func buttonSelectHighlightFlip(){
        buttonDown = !buttonDown
        if buttonDown{
            backgroundColor = .white
            setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        }else{
            backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        }
    }
    
    @objc private func buttonClicked(){
        buttonSelectHighlightFlip()
        filterButtonDelegate?.didClick(filterType: self.filterType!, title: self.currentTitle!, buttonDown: self.buttonDown)
    }
}

