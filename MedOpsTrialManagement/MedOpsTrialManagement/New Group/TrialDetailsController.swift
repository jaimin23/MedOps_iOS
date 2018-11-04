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
    @IBOutlet weak var trialStatusBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersArray.removeAll()
        trialNameLbl.text = _trial?.name
        // Do any additional setup after loading the view.
        self.userView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        userView.delegate = self
        userView.dataSource = self
        changeStatusButton()
    }
    
    @IBAction func onChangeTrialStatus(_ sender: Any) {
        var title = ""
        var message = ""
        var action : UIAlertAction
        if (_trial?.status == Status.Todo){
            title = "Begin Trial"
            message = "Are you sure you wish to begin the trial? This action cannot be reversed and certain management features will be lost!"
            action = UIAlertAction(title: "Begin Trial", style: .destructive, handler: { action in
                self.beginTrial()
            })
        } else {
            title = "Complete Trial"
            message = "You are about to complete the trial. Patient evaluations will be archived. Please ensure any evaluations which remain are completed."
            action = UIAlertAction(title: "Complete Trial", style: .destructive, handler: {action in
                self.completeTrial()
            })
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func beginTrial(){
        if let trial = _trial{
            API.StartTrial(trialId: trial.id, onComplete: {(success) in
                if (success) {
                    self.displayMessage(header: "Success", message: "Trial successfully started!")
                    self._trial?.status = Status.InProgress
                    self.changeStatusButton()
                } else {
                    self.displayMessage(header: "Failure", message: "Unable to begin the trial. Please try again")
                }
            })
        }
    }
    
    func displayMessage(header: String, message: String){
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func completeTrial(){
        
    }
    
    func changeStatusButton(){
        if (_trial?.status == Status.Todo){
            trialStatusBtn.title = "Start Trial"
        } else if (_trial?.status == Status.InProgress){
            trialStatusBtn.title = "Complete Trial"
        }
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
