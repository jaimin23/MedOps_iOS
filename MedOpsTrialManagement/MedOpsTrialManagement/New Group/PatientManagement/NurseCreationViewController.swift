//
//  NurseCreationViewController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-12-01.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class NurseCreationViewController: UIViewController {
    
    let defaultPassword = "Passw0rd@"
    
    var trialId = 0

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onRegisterNurse(_ sender: Any) {
        
        let nurse = PIRegistration(email: emailField.text!, pass: defaultPassword, first: firstNameField.text!, last: lastNameField.text!)
        
        let api = APIManager()
        
        api.registerNurse(user: nurse, trialId: trialId, handler: {result in
            
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
