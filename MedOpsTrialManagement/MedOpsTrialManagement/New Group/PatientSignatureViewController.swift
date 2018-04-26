//
//  PatientSignatureViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-04-26.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit


class PatientSignatureViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func saveSigBtnPressed(_ sender: Any){
        let trailFormPage = storyboard?.instantiateViewController(withIdentifier: "TrialDataCollectionForm")
        self.present(trailFormPage!, animated: true, completion: nil)
    }
}
