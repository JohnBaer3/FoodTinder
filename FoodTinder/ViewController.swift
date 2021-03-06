//
//  ViewController.swift
//  FoodTinder
//
//  Created by John Baer on 10/15/20.
//

import UIKit

class MainPageVC: UIViewController {
        
    var yelpCaller: YelpCaller = YelpCaller()
    
    var restaurants = [RestaurantListViewModel]()
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width,
                                 height: view.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(RestaurantCVC.self, forCellWithReuseIdentifier: RestaurantCVC.identifier)
        collectionView?.isPagingEnabled = true
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        
        yelpCaller.yelpCall(parameters:[], completion: {[weak self] result in
            switch result{
            case .success(let data):
                self?.restaurants.append(contentsOf: data)
                DispatchQueue.main.async { [weak self] in
                    self!.collectionView?.reloadData()
                }
            case .failure(_):
                break
            }
        })
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    override var shouldAutorotate: Bool {
        return true
    }
}

extension MainPageVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCVC.identifier,
                                                      for: indexPath) as! RestaurantCVC
        cell.configure(with: restaurants[indexPath.row])
        return cell
    }
}

