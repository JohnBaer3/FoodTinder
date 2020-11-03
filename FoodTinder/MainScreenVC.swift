//
//  ViewController.swift
//  FoodTinder
//
//  Created by John Baer on 10/15/20.
//

import UIKit

class MainScreenVC: UIViewController, UICollectionViewDelegate {
        
    var yelpCaller: YelpCaller = YelpCaller()
    var restaurants = [RestaurantListViewModel]()
    var likedRestaurants:[String] = []
    var superLikedRestaurants:[String] = []
    private var collectionView: UICollectionView?
    var filterList: [(filterType: filterTypes, content: Any)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appD = AppDelegate()
        filterList.append((filterType: .location, content: [Double(appD.locVal?.latitude ?? 37.2638), Double(appD.locVal?.longitude ?? -122.0230)]))

        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width,
                                 height: view.frame.size.height-10)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(RestaurantCVC.self, forCellWithReuseIdentifier: RestaurantCVC.identifier)
        collectionView?.isPagingEnabled = true
        collectionView?.dataSource = self
        collectionView?.delegate = self
        view.addSubview(collectionView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        yelpCall(parameters: filterList)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCVC.identifier,
                                                      for: indexPath) as! RestaurantCVC
        cell.configure(with: restaurants[indexPath.row])
        cell.restaurantCellDelegate = self
        cell.tag = indexPath.row
        return cell
    }
}


extension MainScreenVC: RestaurantCollectionViewCellDelegate{
    func didTapLike(with model: RestaurantListViewModel){
        likedRestaurants.append(model.name)
        print(likedRestaurants)
    }
    
    func didTapSuperLike(with model: RestaurantListViewModel){
        superLikedRestaurants.append(model.name)
        print("super!! ", superLikedRestaurants)
    }
    
    func didTapList() {
        //Pop out the VC and pass in the likedRestaurants and the superLikedRestaurants
        //Make each of the buttons in likedButtons to link to their Yelp page
        
        print("haha")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LikedRestaurantsScreenVC") as! LikedRestaurantsScreenVC
        self.present(nextViewController, animated:true, completion:nil)
    }
}



extension MainScreenVC: FilterScreenDelegate{
    func filterList(filterList: [(filterType: filterTypes, content: String)]){
        self.filterList = filterList
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
