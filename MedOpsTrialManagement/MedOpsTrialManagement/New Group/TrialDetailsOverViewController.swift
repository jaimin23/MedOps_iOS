//
//  TrialDetailsOverViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-11-29.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit
import Charts

class TrialDetailsOverViewController: UIViewController {
    
    var _trial : Trial?
    @IBOutlet weak var trialNameLbl: UILabel!
    @IBOutlet weak var patientCountLbl: UILabel!
    @IBOutlet weak var branchListView: UITableView!
    @IBOutlet weak var trialStatusLbl: UILabel!
    @IBOutlet weak var startDataLbl: UILabel!
    @IBOutlet weak var finishDataLbl: UILabel!
    @IBOutlet weak var trialStatusBtn: UIButton!
    @IBOutlet weak var pieChartView: PieChartView!
    var patientList: [User] = []
    var api = APIManager()
    var trialId = 0
    var users: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as? TrialTabController
        _trial = tbvc?._trial
        self.trialId = (_trial?.id)!
        //let users = _trial?.users ?? []
        getPatientData()
        self.branchListView.delegate = self
        self.branchListView.dataSource = self
        trialNameLbl.text = _trial?.name
        patientCountLbl.text = String(patientList.count)
        trialStatusLbl.text = getCompletedValue(completed: (_trial?.completed)!)
        startDataLbl.text = _trial?.startDate
        finishDataLbl.text = _trial?.targetEndDate
        // Do any additional setup after loading the view.
        changeStatusButton()
    }
    
    func getPatientData(){
        api.getAllUsersByTrial(trialId: self.trialId) { (users) in
            DispatchQueue.main.async {
                self.users = users
                self.getPatients(users: users)
                if(self.patientList.count != 0){
                    self.setupPieChart(item: self.patientList)
                }
                self.patientCountLbl.text = String(self.patientList.count)
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
    //Get all the patients from the list as other actors such as doctor, nurse are not patients
    func getPatients(users: [User]) -> Void{
        for patient in users{
            if(patient.userType == 0){
                patientList.append(patient)
            }
        }
    }
    
    func getCompletedValue(completed: Bool) -> String{
        if(completed){
            return "Completed"
        }
        else{
            return "On Going"
        }
    }
    
    func setupPieChart(item: [User]){
        var pieCharEntries = [PieChartDataEntry]()
        var genders = ["Male","Female"]
        var maleCount = 0
        var femaleCount = 0
        for gender in (item){
            if(gender.gender!.elementsEqual("female")){
                femaleCount += 1
            }
            else{
                maleCount += 1
            }
        }
        let genderCount = [maleCount, femaleCount]
        for(index, value) in genderCount.enumerated(){
            let entry = PieChartDataEntry()
            entry.y = Double(value)
            entry.label = genders[index]
            pieCharEntries.append(entry)
        }
        let dataSet = PieChartDataSet(values: pieCharEntries, label: "Gender Population")
        dataSet.valueFont = UIFont.systemFont(ofSize: 20)
        dataSet.colors = ChartColorTemplates.joyful()
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.legend.font = UIFont.systemFont(ofSize: 20)
        pieChartView.isUserInteractionEnabled = true
        pieChartView.animate(yAxisDuration: 2.0)
    }
    @IBAction func didPressStatusBtn(_ sender: Any) {
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
            api.StartTrial(trialId: trial.id, onComplete: {(success) in
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
    func completeTrial(){
        if let trial = _trial{
            api.completeTrial(trialId: trial.id) { (success) in
                if(success){
                    self.displayMessage(header: "Success", message: "Trial successfully completed!")
                    self._trial?.status = Status.Completed
                    self.changeStatusButton()
                }else {
                    self.displayMessage(header: "Failure", message: "Unable to complete the trial. Please try again")
                }
            }
        }
    }
    func displayMessage(header: String, message: String){
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func changeStatusButton(){
        trialStatusBtn.layer.cornerRadius = 10
        if (_trial?.status == Status.Todo){
            trialStatusBtn.setTitle("Start Trial", for: .normal)
        } else if (_trial?.status == Status.InProgress){
            trialStatusBtn.setTitle("Complete Trial", for: .normal)
            trialStatusBtn.backgroundColor = UIColor.red
        }
        else if(_trial?.status == Status.Completed){
            trialStatusBtn.setTitle("Trial Completed", for: .disabled)
            trialStatusBtn.backgroundColor = UIColor.gray
        }
    }
    
    
}
extension TrialDetailsOverViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _trial?.branches?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if(_trial?.branches?.count == 0){
            cell.textLabel?.text = "No Branch Available Yet"
        }else{
            cell.textLabel?.text = _trial?.branches?[indexPath.row].hypothesis
        }
        return cell
    }
    
}
