//
//  Questionnaire.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-24.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation

struct Questionnaire: Codable {
    var id: Int
    var title: String
    var questions: [Question]
    var trialId: Int
    
    init(id: Int, title: String, questions: [Question], trialId: Int){
        self.id = id
        self.title = title
        self.questions = questions
        self.trialId = trialId
    }
}
