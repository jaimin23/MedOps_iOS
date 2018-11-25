//
//  Step.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-08.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation

struct Step: Codable {
    var stepId: Int
    var summary: String
    var stepNumber: Int
    var questionnaireId: Int
    
    init(id: Int, summary: String, stepNumber: Int, questionnaireId: Int){
        self.stepId = id
        self.summary = summary
        self.stepNumber = stepNumber
        self.questionnaireId = questionnaireId
    }
}
