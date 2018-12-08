//
//  Trial.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-03.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation

enum Status {
    case Todo
    case InProgress
    case Completed
}

struct TrialStats {
    var branchCount: Int
    var evaluationCount: Int
    var totalNumberOfEvaluations: Int
    
    init(branch: Int, evals: Int, totalEvals: Int) {
        branchCount = branch
        evaluationCount = evals
        totalNumberOfEvaluations = totalEvals
    }
}

class Trial {
    var id: Int
    var name : String
    var completed: Bool
    var users: [User]
    var status: Status
    var branches: [Branch]?
    var startDate: String
    var targetEndDate: String
    var stats: TrialStats?
    
    init(name: String, completed: Bool, id: Int, users:[User], status: Int,
         branches: [Branch], startDate: String, targetEndDate: String){
        self.name = name
        self.completed = completed
        self.id = id
        self.users = users
        if (status == 0){
            self.status = Status.Todo
        } else if (status == 2){
            self.status = Status.InProgress
        } else {
            self.status = Status.Completed
        }
        self.branches = branches
        self.startDate = startDate
        self.targetEndDate = targetEndDate
    }
    
}
