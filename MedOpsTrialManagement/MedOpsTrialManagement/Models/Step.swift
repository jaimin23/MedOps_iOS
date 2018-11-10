//
//  Step.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-08.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation

class Step {
    var id: Int
    var summary: String
    var stepNumber: Int
    
    init(id: Int, summary: String, stepNumber: Int){
        self.id = id
        self.summary = summary
        self.stepNumber = stepNumber
    }
}
