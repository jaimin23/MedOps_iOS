//
//  Utils.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-12-07.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation

func getUserTypeValue(type: Int) -> String{
    switch type {
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

func getDateString(date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy"
    let selectedDate = dateFormatter.string(from: date)
    return selectedDate
}
