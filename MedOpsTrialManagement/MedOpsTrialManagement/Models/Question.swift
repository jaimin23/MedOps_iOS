//
//  Question.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-11.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation

struct Question: Codable{
    var id : Int
    var text : String
    var questionType : Int
    var trialId: Int
    var answers : [Answer]
    var questionPhase: Int
    init(id: Int = 0, text: String, questionType: Int, trialId : Int, questionPhase: Int){
        self.id = id
        self.text = text
        self.questionType = questionType
        self.trialId = trialId
        self.answers = []
        self.questionPhase = questionPhase
    }
}
