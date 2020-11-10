//
//  ViewController.swift
//  FoodTinder
//
//  Created by John Baer on 10/15/20.
//

import UIKit

class MainScreenVC: UIViewController, UICollectionViewDelegate {
        
    @IBOutlet var mainscreen: UIView!
    var yelpCaller: YelpCaller = YelpCaller()
    var restaurants = [RestaurantListViewModel]()
    var likedRestaurants:[SuperOrLikedRestaurants] = []
    var superLikedRestaurants:[SuperOrLikedRestaurants] = []
    private var collectionView: UICollectionView?
    var filterList: [(filterType: filterTypes, content: Any)] = []
    var filterListChanged: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appD = AppDelegate()
        filterList.append((filterType: .location, content: (Double(appD.locVal?.latitude ?? 37.2638), Double(appD.locVal?.longitude ?? -122.0230))))

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

        yelpCall(parameters: filterList)
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
    func didTapLike(with model: RestaurantListViewModel){
        let likedRestaurant = SuperOrLikedRestaurants(restaurantName: model.name, restaurantPic: model.imageUrl, restaurantLatitude: model.latitude, restaurantLongitude: model.longitude, restaurantRating: model.rating, restaurantSuperLiked: false)
        likedRestaurants.append(likedRestaurant)
        print(likedRestaurants)
    }
    
    func didTapSuperLike(with model: RestaurantListViewModel){
        let superLikedRestaurant = SuperOrLikedRestaurants(restaurantName: model.name, restaurantPic: model.imageUrl, restaurantLatitude: model.latitude, restaurantLongitude: model.longitude, restaurantRating: model.rating, restaurantSuperLiked: true)
        superLikedRestaurants.append(superLikedRestaurant)
        print("super!! ", superLikedRestaurants)
    }
    
    func didTapList() {
        //Pop out the VC and pass in the likedRestaurants and the superLikedRestaurants
        //Make each of the buttons in likedButtons to link to their Yelp page
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LikedRestaurantsScreenVC") as! LikedRestaurantsScreenVC
        nextViewController.likedRestaurants = likedRestaurants
        nextViewController.superLikedRestaurants = superLikedRestaurants
        self.present(nextViewController, animated:true, completion:nil)
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

