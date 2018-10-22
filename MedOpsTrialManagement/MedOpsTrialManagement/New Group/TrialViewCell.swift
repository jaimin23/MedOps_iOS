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
    
    func setTrial(trial : Trial){
        _trialId = trial.id
        nameLabel.text = trial.name
    }
}
