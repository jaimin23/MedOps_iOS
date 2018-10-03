//
//  TrailMainController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-04-24.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class TrailMainController:UIViewController{
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func viewTrialBtnPressed(_ sender: Any){
        let trialDataMain = storyboard?.instantiateViewController(withIdentifier: "TrialDataMainPage")
        self.present(trialDataMain!, animated:true, completion: nil)
    }
}
