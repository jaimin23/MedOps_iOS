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
    
    init(id: Int, summary: String, stepNumber: Int){
        self.stepId = id
        self.summary = summary
        self.stepNumber = stepNumber
    }
}
