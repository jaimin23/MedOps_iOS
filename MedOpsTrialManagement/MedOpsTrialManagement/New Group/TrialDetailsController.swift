//
//  TrialDetailsController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-07.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit
import Charts

class TrialDetailsController: UIViewController{
    
    var _trial : Trial?
    var usersArray = [User]()
    let API = APIManager()
    
    @IBOutlet weak var trialNameLbl: UILabel!
    //@IBOutlet var userView: UITableView!
    @IBOutlet weak var barChart: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersArray.removeAll()
        trialNameLbl.text = _trial?.name
        // Do any additional setup after loading the view.
//        self.userView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        userView.delegate = self
//        userView.dataSource = self
//        self.userView.isHidden = true
        self.barChartUpdate()
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
//    @IBAction func selectPatients(_ sender: Any){
//        API.selectPatients(patients: usersArray, completion: {(error) in
//            if let error = error{
//                fatalError(error.localizedDescription)
//            }
//        })
//    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (_trial?.users.count) ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.userView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let userName = self._trial?.users[indexPath.row].firstName
//        let userType = getUserTypeValue(userType: self._trial?.users[indexPath.row].userType ?? 0)
//        let appStatus = getApplicationStatusValue(status: (self._trial?.users[indexPath.row].status) ?? 0)
//        cell.textLabel?.text = "\(userName ?? "None") \(userType) \(appStatus)"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath){
//            cell.accessoryType = .checkmark
//        }
//        self._trial?.users[indexPath.row].status = 1
//        usersArray.append((self._trial?.users[indexPath.row])!)
//        print(usersArray)
//
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath){
//            cell.accessoryType = .none
//        }
//        if(usersArray.count != 0 ){
////            self.usersArray.remove(at: usersArray.index(after: self._trial?.users[indexPath.row]))
//            usersArray.removeAll()
//
//            print(usersArray)
//        }
//    }
    func barChartUpdate(){
        let entry1 = BarChartDataEntry(x: 1.0, y: 50.0)
        let entry2 = BarChartDataEntry(x: 2.0, y: 45.0)
        let entry3 = BarChartDataEntry(x: 3.0, y: 35.0)
        let entry4 = BarChartDataEntry(x: 4.0, y: 25.0)
        let dataSet = BarChartDataSet(values: [entry1, entry2, entry3, entry4], label: "User Answers")
        let data = BarChartData(dataSet: dataSet)
        barChart.data = data
        barChart.chartDescription?.text = "Number of User Answers"
        barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)        
    }
}
