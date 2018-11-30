//
//  LoginUser.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-27.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation

struct LoginUser : Codable {
    var email: String
    var password: String
    
    init(e: String, p: String) {
        email = e
        password = p
    }
}
