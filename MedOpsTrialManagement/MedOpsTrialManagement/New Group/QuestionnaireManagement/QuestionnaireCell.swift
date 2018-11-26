//
//  QuestionnaireCell.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-24.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class QuestionnaireCell: UITableViewCell {
    @IBOutlet weak var questionnaireTItleLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    func setCell(questionnaire: Questionnaire){
        questionnaireTItleLb.text = questionnaire.title
    }
}
