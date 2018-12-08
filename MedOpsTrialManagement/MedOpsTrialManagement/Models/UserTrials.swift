//
//  UserTrials.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-12-05.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation


struct UserTrials {
    var patient : User
    var isApproved : Bool
    
    init(p: User, approved: Bool) {
        patient = p
        isApproved = approved
    }
}
