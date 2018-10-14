//
//  CreateTrialViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-10-03.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit
import Foundation

class CreateTrialViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var trialNameField : UITextField!
    @IBOutlet weak var trialDescription: UITextView!
    @IBOutlet weak var trialDiseasePicker: UIPickerView!
    @IBOutlet weak var trialProcedureType: UIPickerView!
    @IBOutlet weak var trialPrivacyType: UIPickerView!
    @IBOutlet weak var trialDate: UIDatePicker!
    
    var diseaseData = [Diseases]()
    let trialPrivacyTypeData: [Int: String] = [
        1:"Results are kept private",
        2:"Results are limited to participating patients",
        3:"Results are released publically"
    ]
    let trialProcedureTypeData: [Int: String] = [
        1:"Blood Sample",
        2:"Visual Sample",
        3:"Audio Sample"
    ]
    let api = API()
    var trialDiseasesData = [Diseases]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trialPrivacyType.delegate = self
        self.trialPrivacyType.dataSource = self
        
        self.trialProcedureType.delegate = self
        self.trialProcedureType.dataSource = self
        
        self.trialDiseasePicker.delegate = self
        self.trialDiseasePicker.dataSource = self
        
        api.getDiseases{
            diseaseData in
            self.trialDiseasesData = diseaseData
            DispatchQueue.main.async {
                self.trialDiseasePicker.reloadAllComponents()
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func createTrial(_ sender: Any){
        let trialData = TrialModel(
            Name: trialNameField.text!,
            Description: trialDescription.text,
            DiseaseId: trialDiseasePicker.selectedRow(inComponent: 0),
            Procedure: trialProcedureType.selectedRow(inComponent: 0),
            AvailableResults: trialPrivacyType.selectedRow(inComponent: 0) )
        
        api.createTrial(trial: trialData){ (error) in
            if let error = error{
                fatalError(error.localizedDescription)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == trialPrivacyType {
            return trialPrivacyTypeData.count
        }
        else if pickerView == trialProcedureType{
            return trialProcedureTypeData.count
        }
        else{
            return trialDiseasesData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == trialPrivacyType{
            return trialPrivacyTypeData[row]
        }
        else if pickerView == trialProcedureType{
            return trialProcedureTypeData[row]
        }
        else{
            return trialDiseasesData[row].name
        }
    }
    
    
    
}