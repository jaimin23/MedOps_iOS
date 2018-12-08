//
//  TrialListTableViewTableViewController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-03.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

struct CellData{
    let name : String
}

class TrialListController: UIViewController {
    
    @IBOutlet weak var trialList: UITableView!
    var pullToRefresh = UIRefreshControl()
    var _trials : [Trial] = []
    let api = APIManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        pullToRefresh.attributedTitle = NSAttributedString(string: "Fetching Data")
        pullToRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.trialList.addSubview(pullToRefresh)
        
//        let spinner = TrialListController.displaySpinner(onView: self.view)
//        api.getTrials { trialData in
//            self._trials = trialData
//            TrialListController.removeSpinner(spinner: spinner)
//            DispatchQueue.main.async {
//                self.trialList.reloadData()
//            }
//        }
        trialList.delegate = self
        trialList.dataSource = self
        
        
    }

    @objc func refresh(_ sender: Any){
        api.getTrials { trialData in
            self._trials = trialData
            DispatchQueue.main.async {
                self.trialList.reloadData()
                self.pullToRefresh.endRefreshing()
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let spinner = TrialListController.displaySpinner(onView: self.view)
        api.getTrials { trialData in
            self._trials = trialData
            TrialListController.removeSpinner(spinner: spinner)
            DispatchQueue.main.async {
                self.trialList.reloadData()
                self.pullToRefresh.endRefreshing()
            }
        }
    }

}

extension TrialListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _trials.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(_trials[indexPath.row])
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabViewController = segue.destination as? TrialTabController
        if let indexPath = self.trialList.indexPathForSelectedRow {
            let selectedTrial = _trials[indexPath.row]
            tabViewController?._trial = selectedTrial
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trial = _trials[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrialCell") as! TrialViewCell
        
        cell.setTrial(trial: trial)
        
        return cell
    }
}

extension TrialListController {
    //This class will show spinner view and it will run on the main thread of the application
    class func displaySpinner(onView: UIView) -> UIView{
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        return spinnerView
    }
    
    class func removeSpinner(spinner: UIView){
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
