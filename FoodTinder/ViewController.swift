//
//  ViewController.swift
//  FoodTinder
//
//  Created by John Baer on 10/15/20.
//

import UIKit

class ViewController: UIViewController {

    var yelpCaller: YelpCaller = YelpCaller()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yelpCaller.yelpCall()
        
    }


}

