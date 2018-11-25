//
//  BarChartCellView.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-11-25.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation
import UIKit
import Charts

class BarChartCell: UITableViewCell{
    
    @IBOutlet weak var bChartView: BarChartView!
    
    var item: TrialDetailViewModelItem?{
        didSet{
            guard let item = item as? TrialDetailViewModelBarChartItem else{return}
            var barEntries = [BarChartDataEntry]()
            for i in 0..<item.questionData.options.count{
                let dataEntry = BarChartDataEntry(x: Double(i) , y: Double(item.questionData.answers[i].option)!)
                barEntries.append(dataEntry)
            }
            let dataSet = BarChartDataSet(values: barEntries, label: item.questionData.question)
            dataSet.colors = ChartColorTemplates.joyful()
            let data = BarChartData(dataSet: dataSet)
            bChartView.data = data
            bChartView.chartDescription?.text = "Number of User Answers"
            bChartView.xAxis.labelPosition = .bottom
            bChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        }
    }
    static var nib:UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String{
        return String(describing: self)
    }
    
    
}

