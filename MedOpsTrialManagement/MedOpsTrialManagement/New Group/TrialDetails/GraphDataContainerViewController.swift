//
//  GraphDataContainerViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-12-03.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit
import Charts

class GraphDataContainerViewController: UIViewController {
    
    var userResponses: [MockPerson] = []
    var graphType: Int?
    var graphDataType: Int?
    @IBOutlet weak var dataTypePieChart: PieChartView!
    @IBOutlet weak var dataTypeLineChart: LineChartView!
    @IBOutlet weak var dataTypeBarChart: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateCharts(chartDataType: graphDataType!, chartType: graphType!)
        // Do any additional setup after loading the view.
    }
    func generateCharts(chartDataType: Int, chartType: Int) -> Void{
        switch chartType {
        case 0:
            drawBarChart(dataType: chartDataType)
//        case :
//            drawPieChart(dataType: chartDataType)
        case 2:
            drawLineChart(dataType: chartDataType)
        default:break
        }
    }
    
    //Function responsible for drawing the Pie Chart on screen
    func drawPieChart(dataType: Int) -> Void{
        dataTypePieChart.isHidden = false
        dataTypeLineChart.isHidden = true
        dataTypeBarChart.isHidden = true
        let genders = ["male","female"]
        var maleCount = 0
        var femaleCount = 0
        for user in (userResponses){
            if(user.gender.elementsEqual("female")){
                femaleCount += 1
            }
            else{
                maleCount += 1
            }
        }
        var pieChartEntries = [PieChartDataEntry]()
        switch dataType {
        case 0:
            for i in 0..<userResponses.count{
                let dataEntry = PieChartDataEntry(value: Double(userResponses[i].age), label: String(userResponses[i].age))
                pieChartEntries.append(dataEntry)
            }
        case 1:
            let genderCount = [maleCount, femaleCount]
            for(index, value) in genderCount.enumerated(){
                let entry = PieChartDataEntry()
                entry.y = Double(value)
                entry.label = genders[index]
                pieChartEntries.append(entry)
            }
        default:break
        }
        let dataSet = PieChartDataSet(values: pieChartEntries, label: "Patient Population")
        dataSet.colors = ChartColorTemplates.material()
        dataSet.valueFont = UIFont.systemFont(ofSize: 20)
        let data = PieChartData(dataSet: dataSet)
        dataTypePieChart.data = data
        dataTypePieChart.chartDescription?.text = "Data Type"
        dataTypePieChart.xAxis.labelPosition = .bottom
    }
    
    //Function responsible for drawing the Bar Chart on screen
    func drawBarChart(dataType: Int) -> Void{
        dataTypePieChart.isHidden = true
        dataTypeLineChart.isHidden = true
        dataTypeBarChart.isHidden = false
        let genders = ["male","female"]
        var maleCount = 0
        var femaleCount = 0
        for user in (userResponses){
            if(user.gender.elementsEqual("female")){
                femaleCount += 1
            }
            else{
                maleCount += 1
            }
        }
        let genderCount = [maleCount, femaleCount]
        var barEntries = [BarChartDataEntry]()
        switch dataType {
        case 0:
            for i in 0..<userResponses.count{
                let dataEntry = BarChartDataEntry(x: Double(i) , y: Double(userResponses[i].age))
                barEntries.append(dataEntry)
            }
        case 1:
            for i in 0..<genders.count{
                let dataEntry = BarChartDataEntry(x: Double(i) , y: Double(genderCount[i]))
                barEntries.append(dataEntry)
            }
        default:break
        }
        let dataSet = BarChartDataSet(values: barEntries, label: "Patient Population")
        dataSet.colors = ChartColorTemplates.material()
        dataSet.valueFont = UIFont.systemFont(ofSize: 20)
        let data = BarChartData(dataSet: dataSet)
        dataTypeBarChart.data = data
        dataTypeBarChart.chartDescription?.text = "Data Type"
        dataTypeBarChart.xAxis.labelPosition = .bottom
        dataTypeBarChart.legend.font = UIFont.systemFont(ofSize: 12)
        dataTypeBarChart.animate(xAxisDuration: 2.0,yAxisDuration: 2.0)
    }
    
    //Function responsible for drawing the Line Chart on screen
    func drawLineChart(dataType: Int) -> Void{
        dataTypePieChart.isHidden = true
        dataTypeLineChart.isHidden = false
        dataTypeBarChart.isHidden = true
        var chartEntries = [ChartDataEntry]()
        switch dataType {
        case 0:
            for i in 0..<userResponses.count{
                let dataEntry = ChartDataEntry(x: Double(i) , y: Double(userResponses[i].age))
                chartEntries.append(dataEntry)
            }
        default:break
        }
        let dataSet = LineChartDataSet(values: chartEntries, label: "Patient Population")
        dataSet.colors = ChartColorTemplates.material()
        dataSet.valueFont = UIFont.systemFont(ofSize: 20)
        let data = LineChartData(dataSet: dataSet)
        dataTypeLineChart.data = data
        dataTypeLineChart.chartDescription?.text = "Data Type"
        dataTypeLineChart.xAxis.labelPosition = .bottom
        dataTypeLineChart.legend.font = UIFont.systemFont(ofSize: 12)
        dataTypeLineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }

}
