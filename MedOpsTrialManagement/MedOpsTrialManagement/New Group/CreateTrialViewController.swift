//
//  CreateTrialViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-10-03.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit
import SpeechToText
import AVFoundation

class CreateTrialViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate{
    
    @IBOutlet weak var trialNameField : UITextField!
    @IBOutlet weak var trialDescription: UITextView!
    @IBOutlet weak var trialDiseasePicker: UIPickerView!
    @IBOutlet weak var trialProcedureType: UIPickerView!
    @IBOutlet weak var trialPrivacyType: UIPickerView!
    @IBOutlet weak var trialDate: UIDatePicker!
    @IBOutlet weak var micButtonTitle: UIButton!
    @IBOutlet weak var micButtonDescription: UIButton!
    
    var speechToTextService: SpeechToText!
    var isStreaming = false
    var accumulator = SpeechRecognitionResultsAccumulator()
    var diseaseData = [Diseases]()
    let trialPrivacyTypeData: [String] = [
        "Results are kept private",
        "Results are limited to participating patients",
        "Results are released publically"
    ]
    let trialProcedureTypeData: [String] = [
        "Blood Sample",
        "Visual Sample",
        "Audio Sample"
    ]
    let api = APIManager()
    var trialDiseasesData = [Diseases]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trialDescription.text = "Enter Description"
        self.trialDescription.delegate = self
        self.trialPrivacyType.delegate = self
        self.trialPrivacyType.dataSource = self
        
        self.trialProcedureType.delegate = self
        self.trialProcedureType.dataSource = self
        
        self.trialDiseasePicker.delegate = self
        self.trialDiseasePicker.dataSource = self
        self.trialDescription.layer.borderColor = UIColor.black.cgColor
        self.trialDescription.layer.borderWidth = 1.0
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
            AvailableResults: trialPrivacyType.selectedRow(inComponent: 0),
            UserUniqueId: "Random123")
        api.createTrial(trial: trialData, onComplete: {(success) in
            let alert: UIAlertController
            if(!success) {
                alert = UIAlertController(title: "Result", message: "Bad response \(trialData.Name)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                    // TODO
                }))
            } else {
                alert = UIAlertController(title: "Save Complete", message: "Trial Successfully Created!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
            }
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func didPressDecriptionMic(_ sender: Any) {
        speechToTextService = SpeechToText(apiKey: "6SR8RaGBRjXnAOKKimj09gbtJfIuQ9SQyjpM6ITDNP9T")
        if !isStreaming{
            isStreaming = true
            micButtonDescription.setImage(UIImage(named: "icons8-mute-30"), for: .normal)
            let failure = {
                (error: Error) in print(error)
            }
            var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
            settings.interimResults = true
            speechToTextService.recognizeMicrophone(settings: settings, failure: failure) {
                
                results in
                self.accumulator.add(results: results)
                print(self.accumulator.bestTranscript)
                self.trialDescription.text = self.accumulator.bestTranscript
            }
        }
        else{
            isStreaming = false
            micButtonDescription.setImage(UIImage(named: "icons8-microphone-30"), for: .normal)
            speechToTextService.stopRecognizeMicrophone()
        }
        
    }
    @IBAction func cancel(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressMicButton(_ sender: UIButton){
        speechToTextService = SpeechToText(apiKey: "6SR8RaGBRjXnAOKKimj09gbtJfIuQ9SQyjpM6ITDNP9T")
        if !isStreaming{
            isStreaming = true
            micButtonTitle.setImage(UIImage(named: "icons8-mute-30"), for: .normal)
            let failure = {
                (error: Error) in print(error)
            }
            var settings = RecognitionSettings(contentType: "audio/ogg;codecs=opus")
            settings.interimResults = true
            speechToTextService.recognizeMicrophone(settings: settings, failure: failure) {
                
                results in
                self.accumulator.add(results: results)
                print(self.accumulator.bestTranscript)
                self.trialNameField.text = self.accumulator.bestTranscript
                
            }
        }
        else{
            isStreaming = false
            micButtonTitle.setImage(UIImage(named: "icons8-microphone-30"), for: .normal)
            speechToTextService.stopRecognizeMicrophone()
        }
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(self.trialDescription.text.contains("Enter Description")){
            self.trialDescription.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if(self.trialDescription.text.isEmpty){
            textView.text = "Enter Description"
        }
    }
    
}
