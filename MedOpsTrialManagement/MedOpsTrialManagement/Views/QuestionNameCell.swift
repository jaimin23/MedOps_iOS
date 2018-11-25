//
//  QuestionNameCellView.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-11-25.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//
import Foundation
import UIKit



class QuestionNameCell: UITableViewCell{
    @IBOutlet weak var titleLbl: UILabel!
    
    var item: TrialDetailViewModelItem?{
        didSet{
            guard let item = item as? TrialDetailViewModelQuestionItem else {
                return
            }
            titleLbl.text = item.questionTitle
        }
    }

    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
