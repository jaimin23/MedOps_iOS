//
//  User.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-10-14.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation
class User: Codable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var userType: Int?
    var userUniqueId: String
    var status: Int?
    var email: String?
    var address: String?
    var ethnicity: String?
    var age: Int?
    var gender: String?
    var password: String?
    
    init(id: Int, firstName: String, lastName: String, userType: Int, userUniqueId: String, status: Int, email: String, address: String, ethnicity: Int, age: Int, password: String, gender: Int) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.userType = userType
        self.userUniqueId = userUniqueId
        self.status = status
        self.email = email
        self.address = address
        self.ethnicity = getEtnicity(ethnicity: ethnicity)
        self.age = age
        self.password = password
        self.gender = getGernder(gender: gender)
    }
    
    func getEtnicity(ethnicity: Int) -> String{
        switch ethnicity {
        case 0: return "Caucasian"
        case 1: return "Hispanic or Latino"
        case 2: return "Native American"
        case 3: return "African American"
        case 4: return "Asain"
        case 5: return "Other"
        default:
            return ""
        }
    }
    func getGernder(gender: Int) -> String{
        switch gender {
        case 0: return "Male"
        case 1: return "Female"
        case 2: return "Other"
        default:
            return ""
        }
    }
}
