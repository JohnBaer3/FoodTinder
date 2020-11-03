//
//  LikedRestaurantsScreenVC.swift
//  FoodTinder
//
//  Created by John Baer on 10/30/20.
//

import UIKit

class LikedRestaurantsScreenVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var likedRestaurants:[String] = []
    var superLikedRestaurants:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}


extension LikedRestaurantsScreenVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        performSegue(withIdentifier: "ClickedInPostSegue", sender: cell)
    }
}




extension LikedRestaurantsScreenVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superLikedRestaurants.count + likedRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postCell = tableView.dequeueReusableCell(withIdentifier: "PostCellTableViewCell",
                                                     for: indexPath) as! PostCellTableViewCell
        
        return postCell
    }
    
}

