//
//  Branch.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-08.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation

class Branch {
    var id: Int
    var hypothesis: String
    var steps: [Step]
    
    init(id: Int, hyp: String, steps: [Step]){
        self.id = id
        self.hypothesis = hyp
        self.steps = steps
    }
}
