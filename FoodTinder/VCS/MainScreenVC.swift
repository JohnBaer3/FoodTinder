//
//  ViewController.swift
//  FoodTinder
//
//  Created by John Baer on 10/15/20.
//

import UIKit
import CoreData

let currentLocNotificationKey = "co.johnbaer.currLoc"

class MainScreenVC: UIViewController, UICollectionViewDelegate {
        
    @IBOutlet var mainscreen: UIView!
    var yelpCaller: YelpCaller = YelpCaller()
    var restaurants = [RestaurantListViewModel]()
    var likedRestaurants:[SuperOrLikedRestaurants] = []
    var superLikedRestaurants:[SuperOrLikedRestaurants] = []
    private var collectionView: UICollectionView?
    var filterList: [(filterType: filterTypes, content: Any)] = []
    var filterListChanged: Bool = false
    let locationChangeObserver = Notification.Name(currentLocNotificationKey)
    var currentLat: Double? = nil
    var currentLong: Double? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delete this when running on actual phone
        filterList.append((filterType: .location, content: (currentLat ?? 37.77, currentLong ?? -122.4)))
        currentLat = 37.77
        currentLong = -122.4
        yelpCall(parameters: filterList)
        
        
        createObserver()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width,
                                 height: view.frame.size.height-10)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(FirstCVC.self, forCellWithReuseIdentifier: FirstCVC.identifier)
        collectionView?.register(RestaurantCVC.self, forCellWithReuseIdentifier: RestaurantCVC.identifier)
        collectionView?.isPagingEnabled = true
        collectionView?.dataSource = self
        collectionView?.delegate = self
        view.addSubview(collectionView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let popupView = NotifFilterListChangedPopupView(frame: CGRect(x: mainscreen.frame.width-50, y: 10, width: 100, height: 50))
        popupView.alpha = 0.0
        self.view.addSubview(popupView)

        //If the filterList was changed, then make a small popup that indicates that the filterList was
        //  modified
        if filterListChanged{
            showPopupAnimate(popupView)
            filterListChanged = false
        }
    }
    
    func showPopupAnimate(_ view: UIView){
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: 1.0, animations: {
            view.alpha = 1.0
        }, completion: {_ in
            self.disappearPopupAnimate(view)
        });
    }
    
    func disappearPopupAnimate(_ view: UIView){
        UIView.animate(withDuration: 1.5, delay: 1.0, animations: {
            view.alpha = 0.0
        });
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    func yelpCall(parameters: [(filterType: filterTypes, content: Any)]){
        DispatchQueue.global(qos: .userInitiated).async{ [self] in
            yelpCaller.yelpCall(parameters:parameters, completion: {[weak self] result in
                switch result{
                case .success(let data):
                    //Get current cell's indexPath.row
                    let pos = self!.collectionView?.visibleCells.first?.tag
                    if pos != nil{
                        self!.restaurants.removeLast(self!.restaurants.count - pos! - 1)
                    }
                    self?.restaurants.append(contentsOf: data)
                    DispatchQueue.main.async { [weak self] in
                        self!.collectionView?.reloadData()
                    }
                case .failure(_):
                    break
                }
            })
        }
    }
    
    
    func createObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationChanged(_:)), name: locationChangeObserver, object: nil)
    }
    
    @objc func locationChanged(_ notification: NSNotification){
        if let currLocDict = notification.userInfo as NSDictionary? {
            currentLat = (currLocDict["latitude"] as! Double)
            currentLong = (currLocDict["longitude"] as! Double)
            if restaurants.count == 0{
                filterList.append((filterType: .location, content: (currentLat, currentLong)))
                yelpCall(parameters: filterList)
            }
        }
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    override var shouldAutorotate: Bool {
        return true
    }
}

extension MainScreenVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstCVC.identifier,
                                                          for: indexPath) as! FirstCVC
            return firstCell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCVC.identifier,
                                                          for: indexPath) as! RestaurantCVC
            cell.configure(with: restaurants[indexPath.row])
            cell.restaurantCellDelegate = self
            cell.tag = indexPath.row
            return cell
        }
    }
}


extension MainScreenVC: RestaurantCollectionViewCellDelegate{
    func didTapLike(with model: RestaurantListViewModel, selected: Bool){
        let likedRestaurant = SuperOrLikedRestaurants(restaurantName: model.name, restaurantPic: model.imageUrl, restaurantLatitude: model.latitude, restaurantLongitude: model.longitude, restaurantRating: model.rating, restaurantSuperLiked: false, restaurantYelpURL: model.yelpURL)
        if selected{
            save(restaurantData: likedRestaurant)
        }else{
            unsave(restaurantData: likedRestaurant)
        }
    }
    
    func didTapSuperLike(with model: RestaurantListViewModel, selected: Bool){
        let superLikedRestaurant = SuperOrLikedRestaurants(restaurantName: model.name, restaurantPic: model.imageUrl, restaurantLatitude: model.latitude, restaurantLongitude: model.longitude, restaurantRating: model.rating, restaurantSuperLiked: true, restaurantYelpURL: model.yelpURL)
        if selected{
            save(restaurantData: superLikedRestaurant)
        }else{
            unsave(restaurantData: superLikedRestaurant)
        }
    }
    
    func didTapList() {
        //Pop out the VC and pass in the likedRestaurants and the superLikedRestaurants
        //Make each of the buttons in likedButtons to link to their Yelp page
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LikedRestaurantsScreenVC") as! LikedRestaurantsScreenVC
        nextViewController.currentLat = currentLat
        nextViewController.currentLong = currentLong
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func save(restaurantData: SuperOrLikedRestaurants) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RestaurantData", in: managedContext)!
        let restaurant = NSManagedObject(entity: entity, insertInto: managedContext)
        
        restaurant.setValue(restaurantData.restaurantLatitude, forKeyPath: "restaurant_latitude")
        restaurant.setValue(restaurantData.restaurantLongitude, forKeyPath: "restaurant_longitude")
        restaurant.setValue(restaurantData.restaurantName, forKeyPath: "restaurant_name")
        restaurant.setValue((restaurantData.restaurantPic.absoluteString), forKeyPath: "restaurant_pic")
        restaurant.setValue(restaurantData.restaurantRating, forKeyPath: "restaurant_rating")
        restaurant.setValue(restaurantData.restaurantSuperLiked, forKeyPath: "restaurant_super_or_like")
        restaurant.setValue(restaurantData.restaurantYelpURL, forKeyPath: "restaurant_yelp_URL")
    
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func unsave(restaurantData: SuperOrLikedRestaurants) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RestaurantData")
        var restaurants_data: [NSManagedObject] = []
        
        //Here, request the whole list
        do {
            restaurants_data = try managedContext.fetch(fetchRequest) as [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        //Then loop through them, and delete from CoreData any that match
        for x in 0..<restaurants_data.count{
            let restaurant = restaurants_data[x]
            if (restaurant.value(forKey: "restaurant_name") as! String) == restaurantData.restaurantName{ //&&
                //(restaurant.value(forKey: "restaurant_yelp_URL") as! String) == restaurantData.restaurantYelpURL{
                managedContext.delete(restaurant)
            }
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}



extension MainScreenVC: FilterScreenDelegate{
    func filterList(filterList: [(filterType: filterTypes, content: String)], filterListChanged: Bool){
        self.filterList = filterList
        self.filterListChanged = filterListChanged
    }
}




extension MainScreenVC: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let collectionViewPos = collectionView?.visibleCells.first{
            if collectionViewPos.tag + 3 > restaurants.count{
                yelpCall(parameters: filterList)
            }
        }
    }
}

