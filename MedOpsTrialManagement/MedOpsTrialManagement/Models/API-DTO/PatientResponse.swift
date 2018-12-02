//
//  PatientResponse.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-12-02.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation


class PatientResponse {
    var questionText : String
    var answerText : String
    
    init(q: String, a: String) {
        questionText = q
        answerText = a
    }
}
