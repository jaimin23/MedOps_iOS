//
//  TrialViewCell.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-03.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation
import UIKit

class TrialViewCell : UITableViewCell {
    
    
    var _trialId: Int = 0

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var branchCount: UILabel!
    @IBOutlet weak var totalProgressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var percentageLbl: UILabel!
    
    
    func setTrial(trial : Trial){
        _trialId = trial.id
        nameLabel.text = trial.name
        branchCount.text = "\(String(trial.stats?.branchCount ?? 0)) branches"
        
        let completedCount = Float((trial.stats?.evaluationCount)!)
        let totalCount = Float((trial.stats?.totalNumberOfEvaluations)!)
        
        if (totalCount != 0){
            let progress = (completedCount/totalCount)
            
            progressBar.setProgress(progress, animated: false)
            
            percentageLbl.text = "\(Int(progress * 100))%"
            
            
            if (progress == 1){
                progressBar.progressTintColor = UIColor.green
            } else if (progress >= 0.3333){
                progressBar.progressTintColor = UIColor.orange
            } else {
                progressBar.progressTintColor = UIColor.red
            }
            
            
            totalProgressLabel.text = "\(String(trial.stats?.evaluationCount ?? 0)) of \(String(trial.stats?.totalNumberOfEvaluations ?? 0)) evaluations completed"
            
        } else {
            progressBar.setProgress(0, animated: false)
            
            percentageLbl.text = "\(Int(0 * 100))%"
            
            totalProgressLabel.text = "No patients currently enrolled"
        }
        
        
        
        if (trial.status == Status.Todo){
            statusLabel.text = "Setup"
            statusLabel.textColor = UIColor.red
        } else if (trial.status == Status.InProgress){
            statusLabel.text = "In Progress"
            statusLabel.textColor = UIColor.green
        } else if (trial.status ==  Status.Completed){
            statusLabel.text = "Trial Completed"
            statusLabel.textColor = UIColor.black
        }
    }
}
