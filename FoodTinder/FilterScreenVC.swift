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
//  The array should take in different parameters - a Radius, Foods (term, categories), Price, Location filters
class FilterScreenVC: UIViewController {
    var filterList: [(filterType: filterTypes, title: String)] = []
    weak var filterScreenDelegate: FilterScreenDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = FilterButtons(filterType: .foods, title: "ramen")
        button.filterButtonDelegate = self
        view.addSubview(button)
    }
    
    
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

    override func viewDidDisappear(_ animated: Bool) {
        filterScreenDelegate?.filterList(filterList: filterList)
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
    }
}

