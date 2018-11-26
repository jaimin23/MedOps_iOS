//
//  BranchCell.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-09.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class BranchCell: UITableViewCell {

    @IBOutlet weak var branchNameLabel: UILabel!
    @IBOutlet weak var stepCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(branch: Branch){
        branchNameLabel.text = branch.hypothesis
        stepCountLabel.text = "\(branch.steps.count) steps"
    }

}
