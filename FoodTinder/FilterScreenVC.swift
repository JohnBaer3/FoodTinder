//
//  FilterVC.swift
//  FoodTinder
//
//  Created by John Baer on 10/25/20.
//

import UIKit

//How should this work --
//  Make an array of all the filters that I want to add
//  The array should take in different parameters - a Radius, Foods (term, categories), Price, Location filters

class FilterScreenVC: UIViewController {
    
    var filterList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let button = FilterButtons(filterType: .price, title: "hmmmmmm")
        button.filterButtonDelegate = self

        
        view.addSubview(button)
        
    }
    

}


extension FilterScreenVC: FilterButtonDelegate{
    func didClick(filterType: filterTypes, title: String){
        filterList.append(title)
        print(filterList)
    }

}
