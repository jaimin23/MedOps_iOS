//
//  MockGraphData.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-11-22.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//
import Foundation

struct QuestionData{
    var question:String
    var options:[String]
    var answers:[MockPerson]
}

struct MockPerson{
    var gender:String
    var option:String
    var age:Int
}

