//
//  Evalution.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-21.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation

class Evaluation {

    var id: Int
    var date: String
    var patientName: String
    var imageData: Data

    init(id: Int, date: String, name: String, image: Data){
        self.id = id
        self.date = date
        self.patientName = name
        self.imageData = image
    }
}
