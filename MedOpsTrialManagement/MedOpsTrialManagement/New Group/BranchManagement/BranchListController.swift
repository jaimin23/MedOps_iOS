//
//  BranchListController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-09.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class BranchListController: UIViewController {
    
    var trialId: Int = 0
    var branches: [Branch] = []
    var pullToRefresh = UIRefreshControl()
    let api = APIManager()
    
    @IBOutlet weak var branchTable: UITableView!
    
    @IBAction func onAddNewBranch(_ sender: Any) {
        performSegue(withIdentifier: "createBranch", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = self.tabBarController as! TrialTabController
        
        guard let id = tbvc._trial?.id else {return}
        self.trialId = id
        pullToRefresh.attributedTitle = NSAttributedString(string: "Fetching branch data...")
        pullToRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.branchTable.addSubview(pullToRefresh)
        
        api.getBranches(trialId: trialId, onComplete: {(branches) in
            self.branches = branches
            DispatchQueue.main.async {
                self.branchTable.reloadData()
                self.pullToRefresh.endRefreshing()
            }
        })
        
        branchTable.dataSource = self
        branchTable.delegate = self
    }
    
    @objc func refresh(_ sender: Any){
        loadData()
    }
    
    func loadData(){
        api.getBranches(trialId: trialId, onComplete: {(branches) in
            self.branches = branches
            DispatchQueue.main.async {
                self.branchTable.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createBranch"{
            let destination = segue.destination as? CreateBranchController
            destination?.trialId = trialId
        } else if segue.identifier == "showBranch" {
            let destination = segue.destination as? CreateBranchController
            // Since the view is being loaded as read only, the branch details
            // need to be retrieved
            
            if let indexPath = self.branchTable.indexPathForSelectedRow {
                let branch = branches[indexPath.row]
                destination?.trialId = trialId
                destination?.branch = branch
                destination?.readOnly = true
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BranchListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return branches.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
        performSegue(withIdentifier: "showBranch", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let branch = branches[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BranchCell") as! BranchCell
        cell.setCell(branch: branch)
        return cell
    }
}
