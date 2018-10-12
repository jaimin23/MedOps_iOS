//
//  TrialDetailsController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-07.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class TrialDetailsController: UIViewController {
    
    var _trial : Trial?


    @IBOutlet weak var trialNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        trialNameLbl.text = _trial?.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onManageQuestionaire(_ sender: Any) {
//        performSegue(withIdentifier: "showQuestions", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let questionaireList = segue.destination as? QuestionnaireListView
        questionaireList?.trial = _trial
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
