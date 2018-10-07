//
//  Trial.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-03.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation

class Trial {
    var id: Int
    var name : String
    var completed: Bool
    
    init(name: String, completed: Bool, id: Int){
        self.name = name
        self.completed = completed
        self.id = id
    }
}
