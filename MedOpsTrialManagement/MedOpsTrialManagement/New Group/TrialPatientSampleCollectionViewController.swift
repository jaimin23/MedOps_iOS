//
//  TrialPatientSampleCollectionViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-04-26.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit


class TrialPatientSampleCollectionViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func submitDetailBtnPressed(_ sender: Any){
        let trialDataMain = storyboard?.instantiateViewController(withIdentifier: "TrialDataMainPage")
        self.present(trialDataMain!, animated:true, completion: nil)
    }
    
}
