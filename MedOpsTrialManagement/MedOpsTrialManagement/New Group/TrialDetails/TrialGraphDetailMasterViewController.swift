//
//  TrialGraphDetailMasterViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-11-30.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

protocol QuestionSelectionDelegate: class{
    func questionSelected(_ newQuestion: QuestionData)
}

class TrialGraphDetailMasterViewController: UITableViewController {
    
    var graphData: [QuestionData] = []
    
    weak var delegate: QuestionSelectionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        graphData = getGraphData()!
        // Uncomment the following line to preserve selection between presentations
 
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return graphData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = graphData[indexPath.row].question
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SendDataSegue", sender: self)
    }
    
    func getGraphData() -> [QuestionData]?{
        if let url = Bundle.main.url(forResource: "GraphMockData", withExtension: ".json"){
            do{
                let data = try Data(contentsOf: url)
                let jsonData = try JSONSerialization.jsonObject(with: data, options:[])
                guard let jsonArray = jsonData as? [[String:Any]] else{return nil}
                var questionData = [QuestionData]()
                for mockData in jsonArray{
                    let question = mockData["question"] as? String
                    let options = mockData["options"] as? [String]
                    let answers = mockData["answers"] as? [[String:Any]]
                    var mockPersonList:[MockPerson] = []
                    for mockPerson in answers!{
                        let gender = mockPerson["gender"] as? String
                        let option = mockPerson["option"] as? String
                        let age = mockPerson["age"] as? Int
                        let mockP = MockPerson(gender: gender!, option: option!, age: age!)
                        mockPersonList.append(mockP)
                    }
                    let mockQuestionData = QuestionData(question: question!, options: options!, answers: mockPersonList)
                    questionData.append(mockQuestionData)
                }
                return questionData
            }catch{
                print("error:\(error)")
            }
        }
        return nil
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendDataSegue"{
            let indexPaths = self.tableView!.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as NSIndexPath
            let vc = (segue.destination as! UINavigationController).topViewController as! GraphDetailViewController
            vc.question = self.graphData[indexPath.row].question
            vc.questionDetail = self.graphData[indexPath.row]
        }
    
    }

}
