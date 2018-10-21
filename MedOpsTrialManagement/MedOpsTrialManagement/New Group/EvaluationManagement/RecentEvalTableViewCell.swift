//
//  RecentEvalTableViewCell.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-21.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class RecentEvalTableViewCell: UITableViewCell {

    @IBOutlet weak var evalIdLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var patientNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(eval: Evaluation){
        dateLbl.text = eval.date
        patientNameLbl.text = "Evalution #\(eval.id)"
    }
    
    

}
