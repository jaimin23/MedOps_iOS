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
    
    // Determines whether or not to create the view as read only
    var readOnly = false
    
    // For read only field
    var branch : Branch?
    
    var trialId : Int = 0
    let api = APIManager()
    
    var promptedQuestionnaireId = 0
    
    func loadQuestionnaires(){
        // Load the available questionnaires from the list
        self.api.getQuestionnaires(trialId: trialId, onComplete: {questionnaire in
            
            DispatchQueue.main.async {
                self.availableQuestionnaires = questionnaire
                print("questionnaire loading successful")
                if (self.readOnly){
                    self.initReadOnly()
                }
            }

        })
    }
    

    @IBOutlet weak var hypoTextField: UITextField!
    
    @IBOutlet weak var saveBranchBtn: UIButton!
    
    @IBOutlet weak var noBranchLbl: UILabel!
    @IBAction func addStep(_ sender: Any) {
        
        if(readOnly){
            return
        }
        
        
        let alert = UIAlertController(title: "Assign Questionnaire", message: "Would you like to add a new questionnaire or an existing one?", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "New Questionnaire", style: .default, handler:
            { handler in
                self.onCreateNewQuestionnaire()
        }))
        alert.addAction(UIAlertAction(title: "Existing Questionnaire", style: .default, handler: { handler in
            self.onAssignQuestionnaire()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func onCreateNewQuestionnaire(){
        let alert = UIAlertController(title: "Create new Questionnaire", message: "Please provide the name of the questionnaire", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField) in
            
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            var newQuestionnaire = Questionnaire(id: 0, title: textField.text!, questions: [], trialId: self.trialId)
            
            if (textField.text == ""){
        let errorAlert = UIAlertController(title: "Blank Title", message: "No questionnaire title was provided!", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(errorAlert, animated: true)
                return
            }

            self.api.postQuestionnaire(questionnaire: newQuestionnaire, onComplete: {result in
                
                if (result){
                    self.loadQuestionnaires()
                    let resultAlert = UIAlertController(title: "Success", message: "Successfully created the new questionnaire", preferredStyle: .alert)
                    
                    resultAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { handler in
                        newQuestionnaire = self.getQuestionnaire(title: newQuestionnaire.title)!
                        self.createField(questionnaire: newQuestionnaire, step: nil)
                    }))
                    
                    DispatchQueue.main.async {
                         self.present(resultAlert, animated: true)
                    }
                } else {
                    let resultAlert = UIAlertController(title: "Error", message: "An error occured while attempting to create the new questionnaire", preferredStyle: .alert)
                    
                    resultAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        self.present(resultAlert, animated: true)
                    }
                }
            })
        }))
        
        self.present(alert, animated: true)
        

    }
    
    func onAssignQuestionnaire(){
        let alert = UIAlertController(title: "Questionnaire Selection", message: "Please select which questionnaire is to be associated to this step of the branch", preferredStyle: UIAlertControllerStyle.alert)
        
        for q in availableQuestionnaires{
            alert.addAction(UIAlertAction(title: q.title, style: .default, handler: {action in
                self.createField(questionnaire: q, step: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createField(questionnaire: Questionnaire, step: Step?){
        if (noBranchLbl != nil){
            // If it appears, remove it from the view
            noBranchLbl.removeFromSuperview()
            noBranchLbl = nil
        }
        
        // Depending on where the latest text field was placed, place the next one
        // so that it is below it
        let newStepField = UITextField(frame: CGRect(x: 40, y: pivot, width: screenWidth - 400, height: 40))
        let button = UIButton(frame: CGRect(x: screenWidth - 400 + 60, y:pivot, width: 300, height: 40))
        button.backgroundColor = .blue
        button.setTitle(questionnaire.title, for: .normal)
        button.addTarget(self, action: #selector(questionnaireClicked), for: .touchUpInside)
        
        newStepField.font = UIFont.systemFont(ofSize: 17)
        newStepField.keyboardType = UIKeyboardType.default
        newStepField.returnKeyType = UIReturnKeyType.done
        newStepField.borderStyle = UITextBorderStyle.roundedRect
        newStepField.placeholder = "Step Name"
        
        // If the view is in read only mode, disable the field
        if (readOnly){
            newStepField.isUserInteractionEnabled = false
            newStepField.text = step?.summary
        }
        self.view.addSubview(newStepField)
        self.view.addSubview(button)
        pivot += 50
        stepTexts.append(newStepField)
        selectedQuestionnaires.append(questionnaire)
    }
    
    func getQuestionnaire(title: String) -> Questionnaire? {
        for q in availableQuestionnaires{
            if q.title == title {
                return q
            }
        }
        
        return nil
    }
    
    func getQuestionnaire(id: Int) -> Questionnaire? {
        for q in availableQuestionnaires{
            if q.id == id {
                return q
            }
        }
        
        return nil
    }
    
    @objc func questionnaireClicked(sender: UIButton!){
        let questionnaireName = sender.title(for: .normal)!
        print(questionnaireName)
        let selectedQuestionnaire = getQuestionnaire(title: questionnaireName)
        
        promptedQuestionnaireId = (selectedQuestionnaire?.id)!
        performSegue(withIdentifier: "onModifyQuestionnaire", sender: self)
        
        
        
        print("To implement")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "onModifyQuestionnaire"{
            let questionList = segue.destination as? QuestionnaireListView
            questionList?._questionnaireId = promptedQuestionnaireId

        }
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
            
            let branch = Branch(id: 0, hyp: hypoText, steps: steps, trialId: self.trialId)
            
        
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
        // Check the branch name
        if (hypoTextField.text == ""){
            return false
        }
        
        // All fields are filled in
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pivot = noBranchLbl.frame.origin.y
        screenWidth = self.view.frame.size.width
        // Do any additional setup after loading the view.
        
        self.loadQuestionnaires()
    }
    
    func initReadOnly(){
        saveBranchBtn.isHidden = true
        // Set the text and make it read only
        hypoTextField.text = branch?.hypothesis
        hypoTextField.isUserInteractionEnabled = false
        
        
        
        for step in (branch?.steps)! {
            let stepQuestionnaire = getQuestionnaire(id: step.questionnaireId)
            if (stepQuestionnaire == nil){
                // TODO exception handling
                return
            }
            createField(questionnaire: stepQuestionnaire!, step: step)
        }
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
