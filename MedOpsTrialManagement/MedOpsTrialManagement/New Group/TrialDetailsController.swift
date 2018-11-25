//
//  TrialDetailsController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-07.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit
import Charts
import SwiftRangeSlider

class TrialDetailsController: UIViewController{
    
    var _trial : Trial?
    let API = APIManager()
    fileprivate var viewModel = TrialDetailViewModel()
    @IBOutlet weak var trialNameLbl: UILabel!
    @IBOutlet weak var trialStatusBtn: UIBarButtonItem!
    @IBOutlet weak var trialDetailViewTable: UITableView!
//    @IBOutlet weak var rangeSlider: RangeSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as? TrialTabController
        _trial = tbvc?._trial
        trialNameLbl.text = _trial?.name
        trialDetailViewTable.dataSource = viewModel
        
        trialDetailViewTable.rowHeight = UITableViewAutomaticDimension
        trialDetailViewTable.register(QuestionNameCell.nib, forCellReuseIdentifier:QuestionNameCell.identifier)
        trialDetailViewTable.register(BarChartCell.nib, forCellReuseIdentifier: BarChartCell.identifier)
        trialDetailViewTable.register(PieChartCell.nib, forCellReuseIdentifier: PieChartCell.identifier)
        //changeStatusButton()
        // Do any additional setup after loading the view.
//        self.userView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        userView.delegate = self
//        userView.dataSource = self
//        self.userView.isHidden = true
////        self.userView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        userView.delegate = self as! UITableViewDelegate
//        userView.dataSource = self as! UITableViewDataSource
        //changeStatusButton()
    }
    
    @IBAction func onChangeTrialStatus(_ sender: Any) {
        var title = ""
        var message = ""
        var action : UIAlertAction
        if (_trial?.status == Status.Todo){
            title = "Begin Trial"
            message = "Are you sure you wish to begin the trial? This action cannot be reversed and certain management features will be lost!"
            action = UIAlertAction(title: "Begin Trial", style: .destructive, handler: { action in
               // self.beginTrial()
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
    
//    func beginTrial(){
//        if let trial = _trial{
//            API.StartTrial(trialId: trial.id, onComplete: {(success) in
//                if (success) {
//                    self.displayMessage(header: "Success", message: "Trial successfully started!")
//                    self._trial?.status = Status.InProgress
//                    self.changeStatusButton()
//                } else {
//                    self.displayMessage(header: "Failure", message: "Unable to begin the trial. Please try again")
//                }
//            })
//        }
//    }
    
    func displayMessage(header: String, message: String){
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func completeTrial(){
        
    }
    
//    func changeStatusButton(){
//        if (_trial?.status == Status.Todo){
//            trialStatusBtn.title = "Start Trial"
//        } else if (_trial?.status == Status.InProgress){
//            trialStatusBtn.title = "Complete Trial"
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onManageQuestionaire(_ sender: Any) {
//        performSegue(withIdentifier: "showQuestions", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "showEvals"{
//            let evalList = segue.destination as? RecentEvaluationsView
//            if let id = _trial?.id{
//                evalList?._trialId = id
//            }
//
//        }
//        else if segue.identifier == "branch"{
//            let branchList = segue.destination as? BranchListController
//            if let id = _trial?.id {
//                branchList?.trialId = id
//            }
//        }
//        else {
//            let questionaireList = segue.destination as? QuestionnaireListView
//            questionaireList?.trial = _trial
//        }
//    }
}
