//
//  UserListViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-12-06.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var addNurseBtn: UIButton!
    @IBOutlet weak var userListTableView: UITableView!
    var pullToRefresh = UIRefreshControl()
    var trialId = 0
    var _trial: Trial?
    var allUsers: [User] = []
    var users: [User] = []
    let api = APIManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as? TrialTabController
        _trial = tbvc?._trial
        self.trialId = (_trial?.id)!
        pullToRefresh.attributedTitle = NSAttributedString(string: "Fetching Data")
        pullToRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.userListTableView.addSubview(pullToRefresh)
        loadUsers()
        self.userListTableView.delegate = self
        self.userListTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    @objc func refresh(_ sender: Any){
        self.users.removeAll()
        self.allUsers.removeAll()
        self.loadUsers()
        self.pullToRefresh.endRefreshing()
    }
    @IBAction func didPressGoToNurseViewBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "goToNursePage", sender: self)
    }
    func loadUsers(){
        api.getAllUsersByTrial(trialId: self.trialId) { (users) in
            self.allUsers = users
            DispatchQueue.main.async {
                self.getUsers(allUsers: self.allUsers)
                self.userListTableView.reloadData()
            }
        }
    }
    
    func getUsers(allUsers: [User]){
        for user in allUsers{
            if user.userType != 0{
                self.users.append(user)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToNursePage"{
            if let destination = segue.destination as? NurseCreationViewController{
                destination.trialId = self.trialId
            }
        }
    }
 

}
extension UserListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCells") as! AdminTableViewCell
        if(users[indexPath.row].userType != 0){
            cell.setAdminInfo(user: users[indexPath.row])
        }
        return cell
    }
    
    
}
