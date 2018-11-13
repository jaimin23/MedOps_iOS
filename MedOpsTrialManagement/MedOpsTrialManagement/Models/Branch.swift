//
//  Branch.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-08.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation

struct Branch: Codable {
    var id: Int
    var hypothesis: String
    var steps: [Step]
    var trialId: Int
    
    init(id: Int, hyp: String, steps: [Step], trialId: Int){
        self.id = id
        self.hypothesis = hyp
        self.steps = steps
        self.trialId = trialId
    }
}
