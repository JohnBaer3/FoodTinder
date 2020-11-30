//
//  LikedRestaurantsScreenVC.swift
//  FoodTinder
//
//  Created by John Baer on 10/30/20.
//

import UIKit
import CoreData

class LikedRestaurantsScreenVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var restaurants_data: [NSManagedObject] = []
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
        let restaurant = restaurants_data[indexPath.row]
        let restaurantModeled = SuperOrLikedRestaurants(
            restaurantName: restaurant.value(forKey: "restaurant_name") as! String,
            restaurantPic: URL(string: (restaurant.value(forKey: "restaurant_pic") as! String))!,
            restaurantLatitude: (restaurant.value(forKey: "restaurant_latitude") as! Float),
            restaurantLongitude: ((restaurant.value(forKey: "restaurant_longitude") as? Float)!),
            restaurantRating: (restaurant.value(forKey: "restaurant_rating") as! Float),
            restaurantSuperLiked: (restaurant.value(forKey: "restaurant_super_or_like") as! Bool))
        
        if restaurantModeled.restaurantSuperLiked == true{
            superLikedRestaurants.append(restaurantModeled)
        }else{
            likedRestaurants.append(restaurantModeled)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedFoodsTVC",
                                                 for: indexPath) as! LikedFoodsTVC
        cell.configure(restaurantModeled, currentLat!, currentLong!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
