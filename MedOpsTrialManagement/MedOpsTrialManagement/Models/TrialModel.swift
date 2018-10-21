//
//  Trial.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-10-04.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation
struct TrialModel: Codable{
    let Name: String
    let Description: String
    let DiseaseId: Int
    let Procedure: Int
    let AvailableResults: Int
    let UserUniqueId: String
}
