//
//  TrialDetailViewModelItemType.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-11-24.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation
import UIKit

enum TrialDetailViewModelItemType{
    case questionTitle
    case pieChart
    case barChart
}

protocol TrialDetailViewModelItem{
    var type: TrialDetailViewModelItemType {get}
    var rowCount: Int {get}
    var sectionTitle: String {get}
//    var isCollapsible: Bool {get}
//    var isCollapsed: Bool {get}
}

class TrialDetailViewModel: NSObject{
    var items = [TrialDetailViewModelItem]()
    
    override init(){
        super.init()
        let mockData = getGraphData()
        for data in mockData!{
            let questionTitle = data.question
            let questionItem = TrialDetailViewModelQuestionItem(questionTitle:questionTitle)
            items.append(questionItem)
            let questionData = data
            let questionDataItem = TrialDetailViewModelBarChartItem(questionData: questionData)
            items.append(questionDataItem)
            let populationData = data.answers
            if !data.answers.isEmpty{
                let populationDataItem = TrialDetailViewModelPieChartItem(populationData: populationData)
                items.append(populationDataItem)
            }
        }
    }
}
extension TrialDetailViewModel: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
            case .barChart:
                if let cell = tableView.dequeueReusableCell(withIdentifier: BarChartCell.identifier, for: indexPath) as? BarChartCell {
                    cell.item = item
                    return cell
                }
            case .pieChart:
                if let item = item as? TrialDetailViewModelPieChartItem, let cell = tableView.dequeueReusableCell(withIdentifier: PieChartCell.identifier, for: indexPath) as? PieChartCell{
                    let response = item.populationData
                    cell.item = response
                    return cell
                }
            case .questionTitle:
                if let cell = tableView.dequeueReusableCell(withIdentifier: QuestionNameCell.identifier, for: indexPath) as? QuestionNameCell{
                    cell.item = item
                    return cell
                }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
    
}
class TrialDetailViewModelQuestionItem: TrialDetailViewModelItem{

    var type: TrialDetailViewModelItemType{
        return .questionTitle
    }
    var sectionTitle: String{
        return "Question"
    }
    var rowCount: Int{
        return 1
    }
//    var isCollapsible: Bool {
//        return true
//    }
//    var isCollapsed: Bool{
//        return true
//    }
    var questionTitle: String
    init(questionTitle: String){
        self.questionTitle = questionTitle
    }
}

class TrialDetailViewModelBarChartItem: TrialDetailViewModelItem{
    var type: TrialDetailViewModelItemType{
        return .barChart
    }
    
    var sectionTitle: String{
        return "Question Data"
    }
    var rowCount: Int{
        return 1
    }
//    var isCollapsible: Bool{
//        return false
//    }
//    var isCollapsed: Bool{
//        return false
//    }
    var questionData: QuestionData
    init(questionData: QuestionData){
        self.questionData = questionData
    }
}
class TrialDetailViewModelPieChartItem: TrialDetailViewModelItem{
    var type: TrialDetailViewModelItemType{
        return .pieChart
    }
    var sectionTitle: String{
        return "Total Population"
    }
    var rowCount: Int{
        return 1
    }
//    var isCollapsible: Bool{
//        return false
//    }
//    var isCollapsed: Bool{
//        return false
//    }
    var populationData: [MockPerson]
    init(populationData: [MockPerson] ) {
        self.populationData = populationData
    }
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
