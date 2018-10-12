//
//  QuestionaireListView.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-10.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class QuestionnaireListView: UIViewController {
    
    var trial : Trial?
    
    var _trialId : Int = 0;

    @IBOutlet weak var headerLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let trialId = trial?.id {
            headerLbl.text = "Questions for Trial #\(trialId)"
            _trialId = trialId
        } else {
            print("BIG ERROR")
        }

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createQuestionView = segue.destination as? CreateQuestionView
        createQuestionView?.trialId = _trialId
    }
    

}
