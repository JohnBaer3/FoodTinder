//
//  LikedRestaurantsScreenVC.swift
//  FoodTinder
//
//  Created by John Baer on 10/30/20.
//

import UIKit

class LikedRestaurantsScreenVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var likedRestaurants:[SuperOrLikedRestaurants] = []
    var superLikedRestaurants:[SuperOrLikedRestaurants] = []
    var currentLat: Double? = nil
    var currentLong: Double? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
    }
}


extension LikedRestaurantsScreenVC: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath as IndexPath)
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//        performSegue(withIdentifier: "ClickedInPostSegue", sender: cell)
//    }
}




extension LikedRestaurantsScreenVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superLikedRestaurants.count + likedRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tempArr: [SuperOrLikedRestaurants] = []
        var pos = 0
        if indexPath.row < superLikedRestaurants.count{
            tempArr = superLikedRestaurants
            pos = indexPath.row
        }else{
            tempArr = likedRestaurants
            pos = indexPath.row - superLikedRestaurants.count
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedFoodsTVC",
                                                 for: indexPath) as! LikedFoodsTVC
        cell.configure(tempArr[pos], currentLat!, currentLong!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
