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
    
    
    func setTrial(trial : Trial){
        _trialId = trial.id
        nameLabel.text = trial.name
        if (trial.status == Status.Todo){
            statusLabel.text = "Setup"
            statusLabel.textColor = UIColor.red
        } else if (trial.status == Status.InProgress){
            statusLabel.text = "In Progress"
            statusLabel.textColor = UIColor.green
        } else if (trial.status ==  Status.Completed){
            statusLabel.text = "Completed"
            statusLabel.textColor = UIColor.black
        }
    }
}
