//
//  MockGraphData.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-11-22.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//
import Foundation

class QuestionData{
    var question:String
    var options:[String]
    var answers:[MockPerson]
    
    init(question: String, options: [String], answers: [MockPerson]) {
        self.question = question
        self.options = options
        self.answers = answers
    }
}

struct MockPerson{
    var gender:String
    var option:String
    var age:Int
}

struct EvalData{
    var quetion:String
    var answer:String
    var age: Int
    var gender: Int
}
