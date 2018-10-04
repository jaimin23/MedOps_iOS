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
    
    var _trials : [Trial] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let api = APIManager()
        
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

}

extension TrialListTableViewTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _trials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trial = _trials[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrialCell") as! TrialViewCell
        
        cell.setTrial(trial: trial)
        
        return cell
    }
}
