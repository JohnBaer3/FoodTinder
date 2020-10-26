//
//  FilterButtons.swift
//  FoodTinder
//
//  Created by John Baer on 10/25/20.
//

import UIKit

protocol FilterButtonDelegate: AnyObject{
    func didClick(filterType: filterTypes, title: String)
}


class FilterButtons: UIButton {
    weak var filterButtonDelegate: FilterButtonDelegate!
    var filterType: filterTypes?

    
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
        backgroundColor = .orange
        layer.cornerRadius = 20.0
        frame.size = CGSize(width: 100, height: 100)
        
        addTarget(self, action: #selector(buttonClicked), for: .touchDown)
    }
    
    @objc private func buttonClicked(){
        filterButtonDelegate?.didClick(filterType: self.filterType!, title: self.currentTitle!)
    }
}

