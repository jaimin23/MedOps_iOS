//
//  QuestionCell.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-15.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation
import UIKit

class QuestionCell: UITableViewCell {
    
    
    @IBOutlet weak var questionTextLbl: UILabel!
    @IBOutlet weak var answerTypeLbl: UILabel!
    @IBOutlet weak var answerCountLbl: UILabel!
    
    
    func setCell(question: Question){
        questionTextLbl.text = question.text
        
//        var questionType = ""
//        if question.questionType == 0{
//            questionType = "Multiple Select"
//        } else if question.questionType == 1 {
//            questionType = "Numeric"
//        } else {
//            questionType = "Single Select"
//        }
//        
//        answerTypeLbl.text = questionType
//        answerCountLbl.text = " \(question.answers.count) answers"
    }
}
