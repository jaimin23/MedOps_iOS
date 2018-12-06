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
    var password: String?
    
    init(id: Int, firstName: String, lastName: String, userType: Int, userUniqueId: String, status: Int, email: String, address: String, ethnicity: String, age: Int, password: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.userType = userType
        self.userUniqueId = userUniqueId
        self.status = status
        self.email = email
        self.address = address
        self.ethnicity = ethnicity
        self.age = age
        self.password = password
    }
    
    func getName() -> String {
        return self.firstName! + " " + self.lastName!
    }
}
