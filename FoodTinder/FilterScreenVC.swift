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
    var locationFilterList = ["LA", "New York", "Tokyo", "Orange County", "Saratoga"]
    var priceFilterList = ["$", "$$", "$$$", "$$$$"]
    var filterButtons = [FilterButtons]()
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        addFoodsSection()
        addLocationsSection()
        addPriceSection()
    }
    
    
    
    func addFoodsSection(){
        var yPos: Int = 40

        let titleLabel = FilterTitleLabel(title: "FOODS", contentViewWidth: contentView.frame.width, yPos: yPos)
        contentView.addSubview(titleLabel)
        
        yPos = 100
        var xPos = Int(contentView.frame.width/9)
        var xWidth: Int = 0
        for food in foodsFilterList{
            let button = FilterButtons(filterType: .foods, title: food, xPos: xPos, yPos: yPos)
            button.filterButtonDelegate = self
            contentView.addSubview(button)
            xWidth = button.getWidth()
            xPos += (xWidth + 5)
            filterButtons.append(button)
        }
    }
    
    func addLocationsSection(){
        var yPos: Int = 200

        let titleLabel = FilterTitleLabel(title: "LOCATION", contentViewWidth: contentView.frame.width, yPos: yPos)
        contentView.addSubview(titleLabel)
        
        yPos = 250
        var xPos = Int(contentView.frame.width/9)
        var xWidth: Int = 0
        for food in locationFilterList{
            let button = FilterButtons(filterType: .location, title: food, xPos: xPos, yPos: yPos)
            button.filterButtonDelegate = self
            contentView.addSubview(button)
            xWidth = button.getWidth()
            xPos += (xWidth + 5)
            filterButtons.append(button)
        }
    }
    
    func addPriceSection(){
        var yPos: Int = 340

        let titleLabel = FilterTitleLabel(title: "PRICE", contentViewWidth: contentView.frame.width, yPos: yPos)
        contentView.addSubview(titleLabel)
        
        yPos = 390
        var xPos = Int(contentView.frame.width/9)
        var xWidth: Int = 0
        for price in priceFilterList{
            let button = FilterButtons(filterType: .price, title: price, xPos: xPos, yPos: yPos)
            button.filterButtonDelegate = self
            contentView.addSubview(button)
            xWidth = button.getWidth()
            xPos += (xWidth + 5)
            filterButtons.append(button)
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
    
    func unselectFilterButtons(_ filterType: filterTypes, _ title: String){
        if filterType != .categories{
            for button in filterButtons{
                if button.filterType! == filterType && button.title! != title{
                    if button.buttonDown{
                        button.buttonSelectHighlightFlip()
                        removeFromFilterList(filterType, title)
                    }
                }
            }
        }
    }
    
    func removeFromFilterList(_ filterType: filterTypes, _ title: String){
        let pos = contains(a: filterList, v: (filterType, title))
        if pos != -1{
            filterList.remove(at: pos)
        }
    }
}


extension FilterScreenVC: FilterButtonDelegate{
    
    //Add, or remove the clicked button's type and title to filterList
    func didClick(filterType: filterTypes, title: String, buttonDown: Bool){
        if buttonDown{
            filterList.append((filterType: filterType, title: title))
            //Additionally, turn off all filterButtons that are of type filterType - if you can only select
            //  one of its type at a time
            unselectFilterButtons(filterType, title)
        }else{
            removeFromFilterList(filterType, title)
        }
        filterScreenDelegate?.filterList(filterList: filterList)
    }
}

