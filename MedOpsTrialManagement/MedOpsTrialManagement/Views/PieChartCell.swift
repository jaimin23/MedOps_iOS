//
//  PieChartCellView.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-11-25.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation
import UIKit
import Charts

class PieChartCell: UITableViewCell{
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    var item: [MockPerson]? {
        didSet{
            guard let item = item else{return}
            var pieCharEntries = [PieChartDataEntry]()
            var genders = ["Male","Female"]
            var maleCount = 0
            var femaleCount = 0
            for gender in (item){
                if(gender.gender.elementsEqual("female")){
                    femaleCount += 1
                }
                else{
                    maleCount += 1
                }
            }
            let genderCount = [maleCount, femaleCount]
            for(index, value) in genderCount.enumerated(){
                let entry = PieChartDataEntry()
                entry.y = Double(value)
                entry.label = genders[index]
                pieCharEntries.append(entry)
            }
            let dataSet = PieChartDataSet(values: pieCharEntries, label: "Gender Population")
            dataSet.colors = ChartColorTemplates.joyful()
            let data = PieChartData(dataSet: dataSet)
            pieChartView.data = data
            pieChartView.isUserInteractionEnabled = true
            pieChartView.animate(yAxisDuration: 2.0)
        }
    }
    
    static var nib:UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String{
        return String(describing: self)
    }
}
