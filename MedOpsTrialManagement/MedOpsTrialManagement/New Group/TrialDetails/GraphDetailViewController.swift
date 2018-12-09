//
//  GraphDetailViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-11-30.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit
import Charts


class GraphDetailViewController: UIViewController {
    
    @IBOutlet weak var graphTypePicker: UIPickerView!
    //Outlets for overall graph data
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var graphView: BarChartView!
    
    //Outlets for individual graph data
    @IBOutlet weak var dataTypeDetailContainer: UIView!
    @IBOutlet weak var dataTypePicker: UIPickerView!
    @IBOutlet weak var graphDataTypePicker: UIPickerView!
    let graphTypes = ["Bar Chart", "Pie Chart", "Line Chart"]
    let dataTypes = ["Age", "Gender"]
    var questionDetail: QuestionData?
    var question = String()
    var answers: [MockPerson] = []
    var options: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //questionText.text = question
        answers = questionDetail?.answers ?? []
        options = questionDetail?.options ?? []
        self.graphTypePicker.delegate = self
        self.graphTypePicker.dataSource = self
        self.dataTypePicker.delegate = self
        self.dataTypePicker.dataSource = self
        self.graphDataTypePicker.delegate = self
        self.graphDataTypePicker.dataSource = self
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func didPressGenerate(_ sender: Any) {
        switch graphTypePicker.selectedRow(inComponent: 0){
        case 0: generateBarChart()
        case 1: generatePieChart()
        case 2: generateLineChart()
        default:
            break
        }
    }
    @IBAction func didGenerateIndividualDataType(_ sender: Any) {
        let dataTypeDetailViewContainer = storyboard?.instantiateViewController(withIdentifier: "dataGraphViewContainer") as! GraphDataContainerViewController
        dataTypeDetailViewContainer.userResponses = answers
        dataTypeDetailViewContainer.graphType = graphDataTypePicker.selectedRow(inComponent: 0)
        dataTypeDetailViewContainer.graphDataType = dataTypePicker.selectedRow(inComponent: 0)
        self.addChildViewController(dataTypeDetailViewContainer)
        dataTypeDetailViewContainer.view.frame = CGRect(x: 0, y: 0, width: self.dataTypeDetailContainer.frame.size.width, height: self.dataTypeDetailContainer.frame.size.height)
        self.dataTypeDetailContainer.addSubview(dataTypeDetailViewContainer.view)
        dataTypeDetailViewContainer.didMove(toParentViewController: self)
        
        
    }
    
    func generateBarChart(){
        pieChart.isHidden = true
        lineChart.isHidden = true
        graphView.isHidden = false
        var barEntries = [BarChartDataEntry]()
        var entries = [String: Int]()
        for option in options{
            entries[option] = 0
        }
        for answer in answers{
            if entries.keys.contains(answer.option) == true{
                entries[answer.option]! += 1
            }
        }
        let question = questionDetail?.question
        for i in 0..<entries.count{
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(Array(entries)[i].value) , data:options as AnyObject)
            barEntries.append(dataEntry)
        }

        let dataSet = BarChartDataSet(values: barEntries, label: question)
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueFont = UIFont.systemFont(ofSize: 20)
        let data = BarChartData(dataSet: dataSet)
        graphView.data = data
        graphView.chartDescription?.text = "Options for the question"
        graphView.xAxis.labelPosition = .bottom
        graphView.legend.font = UIFont.systemFont(ofSize: 12)
        graphView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
//
    }
    
    func generatePieChart(){
        graphView.isHidden = true
        lineChart.isHidden = true
        pieChart.isHidden = false
        var pieChartEntries = [PieChartDataEntry]()
        var entries = [String: Int]()
        for option in options{
            entries[option] = 0
        }
        for answer in answers{
            if entries.keys.contains(answer.option) == true{
                entries[answer.option]! += 1
            }
        }
        for i in 0..<entries.count{
            let dataEntry = PieChartDataEntry(value: Double(Array(entries)[i].value), label: Array(entries)[i].key)
            pieChartEntries.append(dataEntry)
        }
        let dataSet = PieChartDataSet(values: pieChartEntries, label: "Options for the question")
        dataSet.colors = ChartColorTemplates.material()
        dataSet.valueFont = UIFont.systemFont(ofSize: 20)
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.isUserInteractionEnabled = true
        pieChart.legend.font = UIFont.systemFont(ofSize: 12)
        pieChart.animate(yAxisDuration: 2.0)

    }
    
    func generateLineChart(){
        graphView.isHidden = true
        lineChart.isHidden = false
        pieChart.isHidden = true
        var lineChartEntries = [ChartDataEntry]()
        var entries = [String: Int]()
        for option in options{
            entries[option] = 0
        }
        for answer in answers{
            if entries.keys.contains(answer.option) == true{
                entries[answer.option]! += 1
            }
        }
        for i in 0..<entries.count{
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(Array(entries)[i].value))
            lineChartEntries.append(dataEntry)
        }
        let dataSet = LineChartDataSet(values: lineChartEntries, label: "Options for the question")
        dataSet.colors = ChartColorTemplates.material()
        dataSet.valueFont = UIFont.systemFont(ofSize: 20)
        let data = LineChartData(dataSet: dataSet)
        lineChart.data = data
        lineChart.isUserInteractionEnabled = true
        lineChart.legend.font = UIFont.systemFont(ofSize: 12)
        lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
}
//extension GraphDetailViewController: QuestionSelectionDelegate{
//    func questionSelected(_ newQuestion: QuestionData) {
//        questionDetail = newQuestion
//    }
//}

extension GraphDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == graphTypePicker{
            return graphTypes.count
        }else if pickerView == dataTypePicker{
            return dataTypes.count
        }
        else{
            return graphTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == graphTypePicker{
            return graphTypes[row]
        }else if pickerView == dataTypePicker{
            return dataTypes[row]
        }
        else{
            return graphTypes[row]
        }
    }
    
}
