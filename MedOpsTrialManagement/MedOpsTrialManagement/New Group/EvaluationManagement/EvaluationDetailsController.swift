//
//  EvaluationDetailsController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-11.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class EvaluationDetailsController: UIViewController {

    @IBOutlet weak var evalDataImage: UIImageView!
    
    var evaluation: Evaluation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set the image being displayed
        if let eval = evaluation {
            let image = UIImage(data: eval.imageData)
            evalDataImage.image = image

        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
