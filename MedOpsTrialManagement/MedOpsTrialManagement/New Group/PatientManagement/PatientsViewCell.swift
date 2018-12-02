//
//  PatientDetailViewCell.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-11-18.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit
import Foundation

class PatientsViewCell: UITableViewCell{
    
    @IBOutlet weak var uniqueIdLbl: UILabel!
    @IBOutlet weak var applicationStatusLbl: UILabel!
    @IBOutlet weak var userType: UILabel!
    
    func setPatient(patient: User){
        uniqueIdLbl.text = "\(patient.firstName!) \(patient.lastName!)"
        userType.text = getUserTypeValue(userType: patient.userType!)

        if patient.userType != 0{
            applicationStatusLbl.text = "Evaluating Patients"
        } else {
            applicationStatusLbl.text = getApplicationStatusValue(status: patient.status!)
        }
    }
    
    func getUserTypeValue(userType: Int) -> String{
        switch userType {
        case 0:
            return "Patient"
        case 1:
            return "Doctor"
        case 2:
            return "Nurse"
        case 3:
            return "PI"
        default:
            return "No value founc"
        }
    }
    
    
    func getApplicationStatusValue(status: Int) -> String{
        switch status {
        case 0:
            return "Pending"
        case 1:
            return "Approved"
        default:
            return "No value founc"
        }
    }
}
