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
    
    @IBOutlet weak var branchTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var api = APIManager()
        
        api.getBranches(trialId: trialId, onComplete: {(branches) in
            self.branches = branches
            DispatchQueue.main.async {
               self.branchTable.reloadData()
            }
        })
        
        branchTable.dataSource = self
        branchTable.delegate = self
        
        
        

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

}

extension BranchListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return branches.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let branch = branches[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BranchCell") as! BranchCell
        cell.setCell(branch: branch)
        return cell
    }
}
