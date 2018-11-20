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
    
    var _questions : [Question] = []

    @IBOutlet weak var questionnaireList: UITableView!
    @IBOutlet weak var headerLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! TrialTabController
        trial = tbvc._trial
        if let trialId = trial?.id {
            headerLbl.text = "Questions for Trial #\(trialId)"
            _trialId = trialId
        } else {
            print("BIG ERROR")
        }
        
        // Load trials
        var question = Question(text: "What is the severity of your cough?", questionType: 3, trialId:  self._trialId, questionPhase: 1)
        question.answers = []
        var questionTwo = Question(text: "What is the temperature of the patient?", questionType: 3, trialId:  self._trialId, questionPhase: 1)
        questionTwo.answers = []
        
        questionnaireList.delegate = self
        questionnaireList.dataSource = self
        
        _questions.append(question)
        _questions.append(questionTwo)

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createQuestionView = segue.destination as? CreateQuestionView
        createQuestionView?.trialId = _trialId
    }
    

}

extension QuestionnaireListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _questions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = _questions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell") as! QuestionCell
        cell.setCell(question: question)
        return cell
    }
    
}
