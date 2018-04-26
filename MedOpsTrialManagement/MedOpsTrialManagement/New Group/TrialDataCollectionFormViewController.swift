//
//  TrialCollectionFromViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-04-25.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class TrialDataCollectionFormViewController: UIViewController{
    @IBOutlet weak var proceedureConfSwitch: UISwitch!
    @IBOutlet weak var gatherSignatureBtn: UIButton!
    @IBOutlet weak var collectDataBtn: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    @IBAction func proceedureSwitch(_ sender: Any){
//        if(proceedureConfSwitch.isOn){
////            print("ON!")
//            gatherSignatureBtn.isEnabled = true
//            collectDataBtn.isEnabled = true
//        }
//        else{
//            gatherSignatureBtn.isEnabled = false
//            collectDataBtn.isEnabled = false
//        }
//    }
    
    @IBAction func gatherSignatureBtnPressed(_ sender: Any){
        let signatureView = storyboard?.instantiateViewController(withIdentifier: "PatientSignatureView")
        self.present(signatureView!, animated: true, completion: nil)
    }
    
    @IBAction func gatherPatientSampleBtnPressed(_ sender: Any){
        let sampleCollectionView = storyboard?.instantiateViewController(withIdentifier: "SampleCollectionView")
        self.present(sampleCollectionView!, animated: true, completion: nil)
    }
    
}
