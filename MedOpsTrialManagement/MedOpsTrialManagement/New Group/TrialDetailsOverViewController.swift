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
    @IBOutlet weak var pieChartView: PieChartView!
    var patientList: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as? TrialTabController
        _trial = tbvc?._trial
        let users = _trial?.users ?? []
        getPatients(users: users)
        self.branchListView.delegate = self
        self.branchListView.dataSource = self
        trialNameLbl.text = _trial?.name
        patientCountLbl.text = String(patientList.count)
        trialStatusLbl.text = getCompletedValue(completed: (_trial?.completed)!)
        startDataLbl.text = _trial?.startDate
        finishDataLbl.text = _trial?.targetEndDate
        if(patientList.count != 0){
            setupPieChart(item: patientList)
        }
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
        dataSet.colors = ChartColorTemplates.joyful()
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.isUserInteractionEnabled = true
        pieChartView.animate(yAxisDuration: 2.0)
    }

}
extension TrialDetailsOverViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _trial?.branches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = _trial?.branches?[indexPath.row].hypothesis
        return cell
    }
    
}
