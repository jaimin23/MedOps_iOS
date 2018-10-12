//
//  Answer.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-11.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation

struct Answer : Codable {
    let value: String
    
    init(value : String) {
        self.value = value
    }
}
