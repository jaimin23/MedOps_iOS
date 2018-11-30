//
//  PIRegistration.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-28.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation


struct PIRegistration : Codable {
    let email : String
    let password: String
    let firstName: String
    let lastName: String
    
    init(email: String, pass: String, first: String, last: String) {
        self.email = email
        self.password = pass
        self.firstName = first
        self.lastName = last
    }
}
