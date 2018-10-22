//
//  TrialDetailsController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-07.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class TrialDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var _trial : Trial?
    var usersArray = [User]()
    let API = APIManager()
    
    @IBOutlet weak var trialNameLbl: UILabel!
    @IBOutlet var userView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        usersArray.removeAll()
        trialNameLbl.text = _trial?.name
        // Do any additional setup after loading the view.
        self.userView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        userView.delegate = self
        userView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onManageQuestionaire(_ sender: Any) {
//        performSegue(withIdentifier: "showQuestions", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showEvals"{
            let evalList = segue.destination as? RecentEvaluationsView
            if let id = _trial?.id{
                evalList?._trialId = id
            }
        
        } else {
            let questionaireList = segue.destination as? QuestionnaireListView
            questionaireList?.trial = _trial
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func selectPatients(_ sender: Any){
        API.selectPatients(patients: usersArray, completion: {(error) in
            if let error = error{
                fatalError(error.localizedDescription)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (_trial?.users.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.userView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let userName = self._trial?.users[indexPath.row].firstName
        let userType = getUserTypeValue(userType: self._trial?.users[indexPath.row].userType ?? 0)
        let appStatus = getApplicationStatusValue(status: (self._trial?.users[indexPath.row].status) ?? 0)
        cell.textLabel?.text = "\(userName ?? "None") \(userType) \(appStatus)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .checkmark
        }
        self._trial?.users[indexPath.row].status = 1
        usersArray.append((self._trial?.users[indexPath.row])!)
        print(usersArray)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .none
        }
        if(usersArray.count != 0 ){
//            self.usersArray.remove(at: usersArray.index(after: self._trial?.users[indexPath.row]))
            usersArray.removeAll()
            
            print(usersArray)
        }
    }
    
    func getUserTypeValue(userType: Int) -> String{
        switch userType {
        case 0:
            return "Patient"
        case 1:
            return "Doctor"
        case 2:
            return "Nurse"
        case 3:
            return "PI"
        default:
            return "No value founc"
        }
    }
    func getApplicationStatusValue(status: Int) -> String{
        
        switch status {
        case 0:
            return "Pending"
        case 1:
            return "Approved"
        default:
            return "No value founc"
        }
    }
}
