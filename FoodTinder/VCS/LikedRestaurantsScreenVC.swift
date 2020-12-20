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
        
        fetchRestaurantsFromCoreData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        
        setUpCloseButton()
    }

    func setUpCloseButton(){
        let button = UIButton(frame: CGRect(x: 0, y: 10, width: 100, height: 50))
        button.setTitle("close", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchDown)
        self.view.addSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchRestaurantsFromCoreData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RestaurantData")
        do {
            restaurants_data = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}


extension LikedRestaurantsScreenVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if indexPath.row < superLikedRestaurants.count{
            if let url = URL(string: superLikedRestaurants[indexPath.row].restaurantYelpURL) {
                UIApplication.shared.open(url)
            }
        }else{
            if let url = URL(string: likedRestaurants[indexPath.row - superLikedRestaurants.count].restaurantYelpURL) {
                UIApplication.shared.open(url)
            }
        }
    }
}




extension LikedRestaurantsScreenVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = restaurants_data[indexPath.row]
                
        let restaurantModeled = SuperOrLikedRestaurants(
            restaurantName: restaurant.value(forKey: "restaurant_name") as! String,
            restaurantPic: URL(string: (restaurant.value(forKey: "restaurant_pic") as! String))!,
            restaurantLatitude: (restaurant.value(forKey: "restaurant_latitude") as! Float),
            restaurantLongitude: ((restaurant.value(forKey: "restaurant_longitude") as? Float)!),
            restaurantRating: (restaurant.value(forKey: "restaurant_rating") as! Float),
            restaurantSuperLiked: (restaurant.value(forKey: "restaurant_super_or_like") as! Bool),
            restaurantYelpURL: (restaurant.value(forKey: "restaurant_yelp_URL") as! String))
            
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
