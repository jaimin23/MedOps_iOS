//
//  CreateQuestionView.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-10.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class CreateQuestionView: UIViewController {
    
    let NUMERIC_ANSWER_TEXT  = "Numeric Answer"
    let SINGLE_SELECT_ANSWER  = "Single Select"
    
    var questionniareId: Int  = 0
    
    var _pickerItems : [String] = [ "Single-Select", "Numeric Answer", "Multi-Select"]
    var _pickerQuestionnairePhase : [String] = ["Before Trial", "Before Evaluation"]

    

    @IBOutlet weak var _questionTypeSelector: UIPickerView!
    @IBOutlet weak var _questionPhaseSelector: UIPickerView!
    
    @IBOutlet weak var _questionText: UITextField!
    
 
    @IBOutlet weak var _answerOne: UITextField!
    @IBOutlet weak var _answerTwo: UITextField!
    @IBOutlet weak var _answerThree: UITextField!
    @IBOutlet weak var _answerFour: UITextField!
    @IBOutlet weak var _answerFive: UITextField!
    
    @IBOutlet weak var _addQuestionBtn: UIToolbar!
    
    override func viewDidLoad() {
        
        
        _questionTypeSelector.dataSource = self
        _questionTypeSelector.delegate = self
        _questionPhaseSelector.delegate = self
        _questionPhaseSelector.dataSource = self
        super.viewDidLoad()
        
        _questionText.delegate = self
        _answerOne.delegate = self
        _answerTwo.delegate = self
        _answerThree.delegate = self
        _answerFour.delegate = self
        _answerFive.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onAddQuestion(_ sender: Any) {
        
        let questionId = _questionTypeSelector.selectedRow(inComponent: 0)
        let questionPhaseId = _questionPhaseSelector.selectedRow(inComponent: 0)
        let questionString = _questionText.text!
        var question = Question(text: questionString, questionType: questionId+1, questionnaireId: self.questionniareId, questionPhase: questionPhaseId)
        
        let apiCaller = APIManager()
        
        if (questionId == 0 || questionId == 2){
            if (_answerOne.text! != ""){
                let answer = Answer(value: _answerOne.text!)
                question.answers.append(answer)
            }
            if (_answerTwo.text != ""){
                let answer = Answer(value: _answerTwo.text!)
                question.answers.append(answer)
            }
            if (_answerThree.text! != ""){
                let answer = Answer(value: _answerThree.text!)
                question.answers.append(answer)
            }
            if (_answerFour.text! != ""){
                let answer = Answer(value: _answerFour.text!)
                question.answers.append(answer)
            }
            if (_answerFive.text! != ""){
                let answer = Answer(value: _answerFive.text!)
                question.answers.append(answer)
            }
        }
        
        apiCaller.postQuestion(question: question, onComplete: {(success) in
            let alert: UIAlertController
            if(!success) {
                alert = UIAlertController(title: "Result", message: "Bad response \(self.questionniareId)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                    // TODO
                }))
            } else {
                alert = UIAlertController(title: "Save Complete", message: "Questionnaire Successfully Saved!", preferredStyle: UIAlertControllerStyle.alert)
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

extension CreateQuestionView: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == _questionTypeSelector{
            return _pickerItems.count
        }
        else if pickerView == _questionPhaseSelector{
            return _pickerQuestionnairePhase.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == _questionTypeSelector{
            return _pickerItems[row]
        }
        else if pickerView == _questionPhaseSelector{
            return _pickerQuestionnairePhase[row]
        }
        else{
            return ""
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
