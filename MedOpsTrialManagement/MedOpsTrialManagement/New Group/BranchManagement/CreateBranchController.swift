//
//  CreateBranchController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-08.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class CreateBranchController: UIViewController {
    
    var pivot: CGFloat = 0
    var screenWidth: CGFloat = 0
    // Keeps track of the steps which have been created
    var stepTexts : [UITextField] = []
    // The questionnaires which the researcher can select from
    var availableQuestionnaires : [Questionnaire] = []
    // Tracks the questionnaires selected by the researcher
    var selectedQuestionnaires : [Questionnaire] = []
    var trialId : Int = 0
    let api = APIManager()
    

    @IBOutlet weak var hypoTextField: UITextField!
    @IBOutlet weak var noBranchLbl: UILabel!
    @IBAction func addStep(_ sender: Any) {
        
        if (availableQuestionnaires.count == 0){
            let alert = UIAlertController(title: "No Available Questionnaires", message: "There are no available questionnaires. Please create one from the Questionnaire Management Panel", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let alert = UIAlertController(title: "Questionnaire Selection", message: "Please select which questionnaire is to be associated to this step of the branch", preferredStyle: UIAlertControllerStyle.alert)
        
        for q in availableQuestionnaires{
            alert.addAction(UIAlertAction(title: q.title, style: .default, handler: {action in
                self.createField(questionnaire: q)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createField(questionnaire: Questionnaire){
        if (noBranchLbl != nil){
            // If it appears, remove it from the view
            noBranchLbl.removeFromSuperview()
            noBranchLbl = nil
        }
        
        // Depending on where the latest text field was placed, place the next one
        // so that it is below it
        let newStepField = UITextField(frame: CGRect(x: 40, y: pivot, width: screenWidth - 80, height: 40))
        newStepField.font = UIFont.systemFont(ofSize: 17)
        newStepField.keyboardType = UIKeyboardType.default
        newStepField.returnKeyType = UIReturnKeyType.done
        newStepField.borderStyle = UITextBorderStyle.roundedRect
        newStepField.placeholder = "Step Name"
        self.view.addSubview(newStepField)
        pivot += 50
        stepTexts.append(newStepField)
        selectedQuestionnaires.append(questionnaire)
    }
    
    @IBAction func saveBranch(_ sender: Any) {
        // CHeck to see that all the available fields are filled in
        if (!allFieldsFilled()){
            // One or more fields are empty, prompt the user to fill it in
            let alert = UIAlertController(title: "Empty Field", message: "One or more fields contain an empty value. Please ensure that all fields are filled", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        } else {
            // ALl fields are filled
            var steps: [Step] = []
            var counter : Int = 1
            // Build all the steps
            for field in stepTexts {
                guard let stepSumary = field.text else {return}
                let newStep = Step(id: 0, summary: stepSumary, stepNumber: counter, questionnaireId: selectedQuestionnaires[counter-1].id)
                counter+=1
                steps.append(newStep)
            }
            
            // Build the branch
            guard let hypoText = hypoTextField.text else {return}
            
            var branch = Branch(id: 0, hyp: hypoText, steps: steps, trialId: self.trialId)
            
        
            // send a POST request with the new data created
            api.postBranch(branch: branch, onComplete:{(success) in
            let alert: UIAlertController
                // Check to see if the POST was successful
                if(!success) {
                    // Failed, allow the user to retry
                    alert = UIAlertController(title: "Result", message: "Bad response", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                        // TODO
                    }))
                } else {
                    // Success, bring the user back to the list of branches
                    alert = UIAlertController(title: "Save Complete", message: "The branch with its steps was successfully saved!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                }
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            })
            
        }
    }
    
    func allFieldsFilled() -> Bool{
        // CHecks to see if all the steps are filled in
        for field in stepTexts {
            if (field.text == ""){
                // Empty field detected, return false
                return false
            }
        }
        // All fields are filled in
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pivot = noBranchLbl.frame.origin.y
        screenWidth = self.view.frame.size.width
        // Do any additional setup after loading the view.
        
        // Load the available questionnaires from the list
        self.api.getQuestionnaires(trialId: trialId, onComplete: {questionnaire in
            self.availableQuestionnaires = questionnaire
            print("questionnaire loading successful")
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
