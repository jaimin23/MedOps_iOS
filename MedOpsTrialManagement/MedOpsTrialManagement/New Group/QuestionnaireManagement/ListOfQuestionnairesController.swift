//
//  ListOfQuestionnairesController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-24.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class ListOfQuestionnairesController: UIViewController {
    
    var trial : Trial?
    var trialId : Int = 0
    var questionnaires: [Questionnaire] = []
        var api = APIManager()
    
    @IBAction func onAddQuestionnaire(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Questionnaire", message: "Please provide the title of the questionnaire", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: {(titleField) in
            titleField.placeholder = "Enter..."
        })
        
        guard let trialId = trial?.id else {return}
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: { action in
            let questionnaireTitle = alert.textFields![0] as UITextField
            
            if (questionnaireTitle.text == ""){
                let errorAlert = UIAlertController(title: "Blank Title", message: "No questionnaire title was provided!", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(errorAlert, animated: true)
                return
            }
            
            
            // Add it
            let questionnaire = Questionnaire(id: 0, title: questionnaireTitle.text!, questions: [], trialId: trialId)
            self.api.postQuestionnaire(questionnaire: questionnaire, onComplete: { result in
                if(result){
                    self.loadQuestions()
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    @IBOutlet weak var questionnaireListView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = self.tabBarController as! TrialTabController
        trial = tbvc._trial
        
        guard let id = trial?.id else {return}
        self.trialId = id
        
        self.questionnaireListView.delegate = self
        self.questionnaireListView.dataSource = self
        loadQuestions()
        
    

    }
    
    func loadQuestions() {
        api.getQuestionnaires(trialId: self.trialId, onComplete: { (questionnaire) in
            self.questionnaires = questionnaire;
            
            DispatchQueue.main.async {
                self.questionnaireListView.reloadData()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestions"{
            let questionList = segue.destination as? QuestionnaireListView
            if let indexPath = self.questionnaireListView.indexPathForSelectedRow {
                let questionnaireId = questionnaires[indexPath.row].id
                
                questionList?._questionnaireId = questionnaireId
            }
        }
    }
    
}

extension ListOfQuestionnairesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionnaires.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
        performSegue(withIdentifier: "showQuestions", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let questionnaire = questionnaires[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Questionnaire Cell") as! QuestionnaireCell
        cell.setCell(questionnaire: questionnaire)
        return cell
    }
    
}


