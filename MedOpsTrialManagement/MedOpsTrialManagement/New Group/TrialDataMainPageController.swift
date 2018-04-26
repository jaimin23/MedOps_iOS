//
//  TrialDataMainPage.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-04-24.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class TrialDataMainPageController:UIViewController{
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func analyzeNewPatientBtnPressed(_ sender: Any){
        let trialFromView = storyboard?.instantiateViewController(withIdentifier: "TrialDataCollectionForm")
        self.present(trialFromView!, animated:true, completion: nil)
    }
    
}
