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

class TrialListTableViewTableViewController: UIViewController {
    
    @IBOutlet weak var trialList: UITableView!
    var pullToRefresh = UIRefreshControl()
    var _trials : [Trial] = []
    let api = APIManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        pullToRefresh.attributedTitle = NSAttributedString(string: "Fetching Data")
        pullToRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.trialList.addSubview(pullToRefresh)
        
        
        api.getTrials { trialData in
            print("Printing trial data")
            print(trialData)
            self._trials = trialData
            DispatchQueue.main.async {
                self.trialList.reloadData()
            }
        }
        print("Printing trials now")
        print(_trials)
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

}

extension TrialListTableViewTableViewController: UITableViewDataSource, UITableViewDelegate {
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
