//
//  MyFeedVC.swift
//  SocialStudying
//
//  Created by John Baer on 9/19/20.
//  Copyright © 2020 John Baer. All rights reserved.
//

import UIKit

//This PageViewController is for the swiping effect to navigate between the Home Pages
//Also grabs the user's data
class SwipeEffectController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pages = [UIViewController]()

        override func viewDidLoad() {
            super.viewDidLoad()
            self.delegate = self
            self.dataSource = self
            
            let mainScreen: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "MainScreen")
            let filterScreen: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "FilterScreen")
            
            pages.append(filterScreen)
            pages.append(mainScreen)

            setViewControllers([mainScreen], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
           
            let cur = pages.firstIndex(of: viewController)!

            // if you prefer to NOT scroll circularly, simply add here:
             if cur == 0 { return nil }

            var prev = (cur - 1) % pages.count
            if prev < 0 {
                prev = pages.count - 1
            }
            return pages[prev]
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
            
            let cur = pages.firstIndex(of: viewController)!

            // if you prefer to NOT scroll circularly, simply add here:
             if cur == (pages.count - 1) { return nil }

            let nxt = abs((cur + 1) % pages.count)
            return pages[nxt]
        }

        func presentationIndex(for pageViewController: UIPageViewController)-> Int {
            return pages.count
        }


}
