//
//  RecentEvaluationsView.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-21.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class RecentEvaluationsView: UIViewController {
    
    var _trialId = 0;
    
    var _patientId = 0;
    
    var _evaluations: [Evaluation] = []
    
    var _evaluationProfile: EvaluationProfile?
    
    var activityIndi: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var patientNameLbl: UILabel!
    @IBOutlet weak var branchNameLbl: UILabel!
    @IBOutlet weak var stepNumberLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    
    @IBOutlet weak var evaluationList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = APIManager()
    
        
        evaluationList.delegate = self
        evaluationList.dataSource = self
        
    
        
        activityIndi.startAnimating()
        

        
        api.getPatientEvaluations(patientId: _patientId, trialId: _trialId, onComplete: { (evals) in
            self._evaluationProfile = evals
            self._evaluations = (self._evaluationProfile?.evaluations)!
            DispatchQueue.main.async {
                self.evaluationList.reloadData()
                self.patientNameLbl.text = self._evaluationProfile?.patient.getName()
                self.branchNameLbl.text = self._evaluationProfile?.branch.hypothesis
                self.stepNumberLbl.text = "\(self._evaluationProfile?.currentStepNumber ?? 0)"
                self.statusLbl.layer.masksToBounds = true
                self.statusLbl.layer.cornerRadius = 10
                if ((self._evaluationProfile?.active)!){
                    self.statusLbl.text = "Awaiting next evaluation"
                    self.statusLbl.backgroundColor = UIColor.orange
                } else {
                    self.statusLbl.text = "Completed all evaluations"
                }
                
                
            }
        })

        // Do any additional setup after loading the view.
    }

}

extension RecentEvaluationsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _evaluations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
        print(indexPath.row)
        performSegue(withIdentifier: "showEval", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eval = _evaluations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentEvalCell") as! RecentEvalTableViewCell
        cell.setCell(eval: eval)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let evalDetailsView = segue.destination as? EvaluationDetailsController
        if let indexPath = self.evaluationList.indexPathForSelectedRow {
            let selectedEval = _evaluations[indexPath.row]
            evalDetailsView?.evaluation = selectedEval
        }
    }
    

    
}

