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
    

    @IBOutlet weak var nameLabel: UILabel!
    
    func setTrial(trial : Trial){
        nameLabel.text = trial.name
    }
}
