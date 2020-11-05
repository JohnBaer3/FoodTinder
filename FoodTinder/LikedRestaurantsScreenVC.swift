//
//  LikedRestaurantsScreenVC.swift
//  FoodTinder
//
//  Created by John Baer on 10/30/20.
//

import UIKit
import AlamofireImage

class LikedRestaurantsScreenVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var likedRestaurants:[SuperOrLikedRestaurants] = []
    var superLikedRestaurants:[SuperOrLikedRestaurants] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        let nib = UINib(nibName: "LikedFoodsTVC", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LikedFoodsTVC")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedFoodsTVC",
                                                     for: indexPath) as! LikedFoodsTVC
        var tempArr: [SuperOrLikedRestaurants] = []
        var pos = 0
        if indexPath.row < superLikedRestaurants.count{
            tempArr = superLikedRestaurants
            pos = indexPath.row
        }else{
            tempArr = likedRestaurants
            pos = indexPath.row - superLikedRestaurants.count
        }
        cell.restaurantTitleLabel.text = tempArr[pos].restaurantName
        cell.restaurantImageView.af.setImage(withURL: tempArr[pos].restaurantPic)
        
        return cell
    }
    
}

