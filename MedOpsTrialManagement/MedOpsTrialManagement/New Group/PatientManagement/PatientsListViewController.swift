//
//  PatientsListViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-11-18.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class PatientsListViewController: UIViewController {
    var _trial : Trial?
    var _branches: [Branch] = []
    var _userTrials : [UserTrials] = []
    var api = APIManager()
    var pullToRefresh = UIRefreshControl()
    @IBOutlet weak var patientTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! TrialTabController
        _trial = tbvc._trial
        patientTableView.delegate = self
        patientTableView.dataSource = self
        // TODO switch to api call
        pullToRefresh.attributedTitle = NSAttributedString(string: "Fetching Data")
        pullToRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
        guard let trialId = _trial?.id else {return}
        loadData()
        
        // Do any additional setup after loading the view.
    }
    @objc func refresh(_ sender: Any){
//        api.getTrials { trialData in
//            self._trials = trialData
//            DispatchQueue.main.async {
//                self.trialList.reloadData()
//                self.pullToRefresh.endRefreshing()
//            }
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
    }
    
    func loadData(){
        guard let trialId = _trial?.id else {return}
        api.getBranches(trialId: trialId, onComplete: {result in
        self._branches = result
        })
        
        api.getTrialPatients(trialId: trialId, onComplete: {result in
            self._userTrials = result
            DispatchQueue.main.async {
                self.patientTableView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPatientEval"{
            let evalView = segue.destination as? RecentEvaluationsView
            if let indexPath = self.patientTableView.indexPathForSelectedRow {
                let selectedPatient = _userTrials[indexPath.row].patient
                
                let patientId = selectedPatient.id
                evalView?._patientId = patientId!
                evalView?._trialId = (_trial?.id)!
            }
        } else if segue.identifier == "nurseCreate" {
            let createView = segue.destination as? NurseCreationViewController
            createView?.trialId = (self._trial?.id)!
        }
    }
    
    func displayBranchSelection(patient: User){
        let alert = UIAlertController(title: "Add to Branch", message: "Please select the branch of the trial which this patient will participate in", preferredStyle: .alert)
        
        for b in _branches {
            alert.addAction(UIAlertAction(title: b.hypothesis, style: .default, handler: { action in
                self.approvePatient(branch: b, patient: patient)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func approvePatient(branch: Branch, patient: User){
        guard let id = patient.id else {return}
        api.approvePatient(patientId: id, branchId: branch.id, onComplete: { isSuccess in
            if (isSuccess){
                patient.status = 1
                DispatchQueue.main.async {
                    self.patientTableView.reloadData()
                }
            } else {
                // handle
            }
        })
    }
    
    @IBAction func onAssignNurse(_ sender: Any) {
        let alert = UIAlertController(title: "Nurse Assignment", message: "Would you like to assign an existing or new nurse?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "New", style: .default, handler: {handler in
                self.newNurse()
        }))
        
        alert.addAction(UIAlertAction(title: "Existing", style: .default, handler: {handler in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alert, animated: true)
    }
    
    func newNurse(){
        performSegue(withIdentifier: "nurseCreate", sender: self)
    }
    

}
extension PatientsListViewController: PatientCellDelegate{
    func didTapApprovePatient(patient: User) {
        self.displayBranchSelection(patient: patient)
        
    }
}

extension PatientsListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (_userTrials.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientsCell") as! PatientsViewCell


        cell.setPatient(patient: (_userTrials[indexPath.row].patient))
        if(_userTrials[indexPath.row].patient.userType == 3){
            cell.ApproveBtn.isHidden = true
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = _userTrials[indexPath.row].patient
        
//        if (user.status == 0){
//            let alert = UIAlertController(title: "Approve Patient", message: "This patient is currently pending approval. Would you like to approve them?", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Approve", style: .default, handler: { action in
//                self.displayBranchSelection(patient: user)
//            }))
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            self.present(alert, animated: true)
//        } else {
//            performSegue(withIdentifier: "showPatientEval", sender: self)
//        }
        if(user.status != 0 && user.userType != 3){
            performSegue(withIdentifier: "showPatientEval", sender: self)
        }
    }
    
    
}
