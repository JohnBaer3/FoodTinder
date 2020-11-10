//
//  FilterVC.swift
//  FoodTinder
//
//  Created by John Baer on 10/25/20.
//

import UIKit


protocol FilterScreenDelegate: AnyObject {
    func filterList(filterList: [(filterType: filterTypes, content: String)], filterListChanged: Bool)
}


//How should this work --
//  Make an array of all the filters that I want to add
//  The array should take in different parameters - a Radius, Foods (term), Price, Location filters
class FilterScreenVC: UIViewController {
    var filterList: [(filterType: filterTypes, content: String)] = []
    weak var filterScreenDelegate: FilterScreenDelegate!
    var foodsFilterList = ["Chicken", "Steak", "Korean bbq", "Sushi", "Desserts", "Ice Cream", "Bakeries", "Donuts", "Seafood"]
    var locationFilterList = ["LA", "New York", "Tokyo", "Taiwan", "Cincinnati", "Texas", "Grand Rapids", "Honolulu", "Miami", "Seattle", "San Francisco", "Las Vegas", "Chicago", "Tampa", "Florence", "Rome", "Kyoto", "Singapore", "Paris"]
    var categoriesFilterList = ["Chinese", "American", "Food trucks", "Japanese", "Mexican", "Thai", "Italian", "Indian", "Greek", "Vietnamese"]
    var radiusFilterList = ["0~5 mi", "5~10 mi", "10~15 mi", "15~20 mi", "20~25+ mi"]
    var priceFilterList = ["$", "$$", "$$$", "$$$$"]
    var filterButtons = [FilterButtons]()
    lazy var originalLeftXVal = Int(contentView.frame.width/9)
    var yPos: Int = 40
    var filterListOnScreenAppear: [(filterType: filterTypes, content: String)] = []
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        addFilterSection("FOODS", foodsFilterList, .foods)
        addFilterSection("LOCATION", locationFilterList, .location)
        addFilterSection("CATEGORIES", categoriesFilterList, .categories)
        addFilterSection("RADIUS", radiusFilterList, .radius)
        addFilterSection("PRICE", priceFilterList, .price)
    }
    
    
    
    //Makes each of the Filter Sections
    //Makes the title, then the buttons
    func addFilterSection(_ title: String, _ filterArr: [String], _ filterType: filterTypes){
        let titleLabel = FilterTitleLabel(title: title, contentViewWidth: contentView.frame.width, yPos: yPos)
        contentView.addSubview(titleLabel)
        makeFilterButtonWithType(filterArr, filterType)
    }
    
    //Makes the buttons for each type of filter
    func makeFilterButtonWithType(_ filterArray: [String], _ filterType: filterTypes){
        yPos += 60
        var xPos = originalLeftXVal
        var xWidth: Int = 0

        for food in filterArray{
            let button = FilterButtons(filterType: filterType, title: food, xPos: xPos, yPos: yPos)
            xWidth = button.getWidth()
            xPos = checkXIndent(xWidth, xPos)
            button.xPos! = xPos
            button.filterButtonDelegate = self
            contentView.addSubview(button)
            filterButtons.append(button)
        }
        yPos += 90
    }
    
    func checkXIndent(_ xWidth: Int, _ xPos: Int) -> Int{
        if xPos+xWidth > Int(contentView.frame.width)+50{
            yPos += 60
            return originalLeftXVal
        }
        return xPos+xWidth+5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        filterListOnScreenAppear = filterList
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
    
    func unselectFilterButtons(_ filterType: filterTypes, _ content: String){
        if filterType != .categories{
            for button in filterButtons{
                if button.filterType! == filterType && button.title! != content{
                    if button.buttonDown{
                        button.buttonSelectHighlightFlip()
                        removeFromFilterList(filterType, button.title!)
                    }
                }
            }
        }
    }
    
    func removeFromFilterList(_ filterType: filterTypes, _ content: String){
        let pos = contains(a: filterList, v: (filterType, content))
        if pos != -1{
            filterList.remove(at: pos)
        }
    }
    
    //Checks to see if current filterList is different from filterListOnScreenAppear
    func isFilterListChanged(_ filterList: [(filterType: filterTypes, content: String)]) -> Bool{
        //Go through every element on filterList, and if it matches everything on filterListOnScreenAppear,
        //  then return true, else false
        if filterList.count == filterListOnScreenAppear.count{
            for filterElement in filterList{
                var found = false
                for findElement in filterListOnScreenAppear{
                    if findElement.content == filterElement.content{
                        if findElement.filterType == filterElement.filterType{
                            found = true
                            break
                        }
                    }
                }
                if !found{
                    return true
                }
            }
            return false
        }else{
            return true
        }
    }
}


extension FilterScreenVC: FilterButtonDelegate{
    
    //Add, or remove the clicked button's type and title to filterList
    func didClick(filterType: filterTypes, content: String, buttonDown: Bool){
        if buttonDown{
            filterList.append((filterType: filterType, content: content))
            //Additionally, turn off all filterButtons that are of type filterType - if you can only select
            //  one of its type at a time
            unselectFilterButtons(filterType, content)
        }else{
            removeFromFilterList(filterType, content)
        }
        filterScreenDelegate?.filterList(filterList: filterList, filterListChanged: isFilterListChanged(filterList))
    }
}

