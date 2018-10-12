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
    
    var trialId: Int = 0 // Placeholder value
    
    var _pickerItems : [String] = [ "Multi-Select", "Numeric Answer", "Single-Select"]

    

    @IBOutlet weak var _questionTypeSelector: UIPickerView!
    
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
        let questionString = _questionText.text!
        let question = Question(text: questionString, questionType: questionId, trialId: self.trialId)
        
        let apiCaller = APIManager()
        
        apiCaller.postQuestion(question: question) { (error) in
            let alert: UIAlertController
            if let error = error {
                alert = UIAlertController(title: "Result", message: "Bad response \(self.trialId)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                    // TODO
                }))
                print(error)
                
            } else{
                alert = UIAlertController(title: "Result", message: "Good response \(self.trialId)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension CreateQuestionView: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _pickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _pickerItems[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
