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
        if let trialId = trial?.id {
            headerLbl.text = "Questions for Trial #\(trialId)"
            _trialId = trialId
        } else {
            print("BIG ERROR")
        }
    
        questionnaireList.delegate = self
        questionnaireList.dataSource = self
        let api = APIManager()
        // Load trials
        api.getQuestions(trialId: _trialId, onComplete: { (questions) in
            self._questions = questions;
            
            DispatchQueue.main.async {
                self.questionnaireList.reloadData()
            }
        })
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
