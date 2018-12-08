//
//  TrialDetailPageViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-11-29.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class TrialDetailPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    //This list stores all the view controllers that will be added to the page view
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "overView"),
                self.newVc(viewController: "graphView")]
    }()
    var pageControl = UIPageControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        setupPageControl()
        if let firstViewController = orderedViewControllers.first{
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    //This function loads the view controllers in page view
    func newVc(viewController: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController)else{
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController)else{
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllerCount = orderedViewControllers.count
        
        guard orderedViewControllerCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllerCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    
    func setupPageControl(){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY, width: UIScreen.main.bounds.width, height: 500))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewConontroller = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewConontroller)!
    }
}