//
//  FilterVC.swift
//  FoodTinder
//
//  Created by John Baer on 10/25/20.
//

import UIKit


protocol FilterScreenDelegate: AnyObject {
     func filterList(filterList: [(filterType: filterTypes, title: String)])
}


//How should this work --
//  Make an array of all the filters that I want to add
//  The array should take in different parameters - a Radius, Foods (term), Price, Location filters
class FilterScreenVC: UIViewController {
    var filterList: [(filterType: filterTypes, title: String)] = []
    weak var filterScreenDelegate: FilterScreenDelegate!
    var foodsFilterList = ["Chicken", "Steak", "Korean bbq", "Sushi", "Boba"]
    
    @IBOutlet weak var contentView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFoodsSection()
        
    }
    
    
    
    func addFoodsSection(){
        let titleLabel = FilterTitleLabel(title: "FOODS", contentViewWidth: contentView.frame.width)
        contentView.addSubview(titleLabel)
        
        var xPos = Int(contentView.frame.width/9)
        var xWidth: Int = 0
        var yPos: Int = 100
        for food in foodsFilterList{
            let button = FilterButtons(filterType: .foods, title: food, xPos: xPos, yPos: yPos)
            button.filterButtonDelegate = self
            contentView.addSubview(button)
            xWidth = button.getWidth()
            xPos += (xWidth + 5)
        }
    }
    
    
    //Helper function for identifiying position of tuples
    func contains(a:[(filterTypes, String)], v:(filterTypes, String)) -> Int {
        var pos = 0
        let (c1, c2) = v
        for (v1, v2) in a {
            if v1 == c1 && v2 == c2 {
                return pos
            }
            pos += 1
        }
        return -1
    }
}


extension FilterScreenVC: FilterButtonDelegate{
    
    //Add, or remove the clicked button's type and title to filterList
    func didClick(filterType: filterTypes, title: String, buttonDown: Bool){
        if buttonDown{
            filterList.append((filterType: filterType, title: title))
        }else{
            let pos = contains(a: filterList, v: (filterType, title))
            if pos != -1{
                filterList.remove(at: pos)
            }
        }
        filterScreenDelegate?.filterList(filterList: filterList)
    }
}

