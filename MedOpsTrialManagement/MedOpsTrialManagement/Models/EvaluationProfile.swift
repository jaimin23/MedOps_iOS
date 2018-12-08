//
//  EvaluationProfile.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-12-05.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation


struct EvaluationProfile {
    var patient: User
    var evaluations: [Evaluation]
    var branch: Branch
    var active: Bool
    var currentStepNumber: Int
    
    init(p: User, e: [Evaluation], b: Branch, a: Bool, st: Int) {
        patient = p
        evaluations = e
        branch = b
        active = a
        currentStepNumber = st
    }
    
    
}
