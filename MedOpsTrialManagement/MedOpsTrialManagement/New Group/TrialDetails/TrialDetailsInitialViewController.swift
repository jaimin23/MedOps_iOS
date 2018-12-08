//
//  TrialDetailsInitialViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-12-01.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class TrialDetailsInitialViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let splitVC = storyboard?.instantiateViewController(withIdentifier: "splitVC") as! UISplitViewController
//        self.addChildViewController(splitVC)
//        splitVC.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
//        self.container.addSubview(splitVC.view)
//        splitVC.didMove(toParentViewController: self)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "graphSplitView"{
//            guard let splitViewController = segue.destination as? UISplitViewController,
//            let leftNavController = splitViewController.viewControllers.first as? UINavigationController,
//            let masterViewController = leftNavController.topViewController as? TrialGraphDetailMasterViewController,
//            let rightNavigationController = splitViewController.viewControllers.last as? UINavigationController,
//            let detailViewController = rightNavigationController.topViewController as? GraphDetailViewController
//                else{ fatalError() }
//            
//            let firstQuestion = masterViewController.graphData.first
//            detailViewController.questionDetail = firstQuestion
//            
//            masterViewController.delegate = detailViewController
//            
//            detailViewController.navigationItem.leftItemsSupplementBackButton = true
//            detailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
//        }
//    }

}
