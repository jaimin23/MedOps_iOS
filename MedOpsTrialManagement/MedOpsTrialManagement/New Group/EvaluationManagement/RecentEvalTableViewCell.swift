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
    @IBOutlet weak var evalDetailsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(eval: Evaluation, step: Step){
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.Z" //date    String    "2018-12-06T18:00:44.1420088"
//        let unwrappedDate = (eval.date)
//        let date = dateFormatter.date(from: unwrappedDate)
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        let dateString = dateFormatter.string(from: date!)
        dateLbl.text = eval.date
        
        let number = step.stepNumber
        let summary = step.summary
        evalDetailsLbl.text = "Evalution #\(number) - \(summary)"
    }
    
    

}
