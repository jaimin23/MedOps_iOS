//
//  CreateBranchController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-08.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class CreateBranchController: UIViewController {
    
    var pivot: CGFloat = 0
    var screenWidth: CGFloat = 0
    var stepTexts : [UITextField] = []
    

    @IBOutlet weak var noBranchLbl: UILabel!
    @IBAction func addStep(_ sender: Any) {
        if (noBranchLbl != nil){
            // If it appears, remove it from the view
            noBranchLbl.removeFromSuperview()
            noBranchLbl = nil
        }
        
        let newStepField = UITextField(frame: CGRect(x: 40, y: pivot, width: screenWidth - 80, height: 40))
        newStepField.font = UIFont.systemFont(ofSize: 17)
        newStepField.keyboardType = UIKeyboardType.default
        newStepField.returnKeyType = UIReturnKeyType.done
        newStepField.borderStyle = UITextBorderStyle.roundedRect
        newStepField.placeholder = "Step Name"
        self.view.addSubview(newStepField)
        pivot += 50
        stepTexts.append(newStepField)
        
    }
    
    @IBAction func saveBranch(_ sender: Any) {
        if (!allFieldsFilled()){
            let alert = UIAlertController(title: "Empty Field", message: "One or more fields contain an empty value. Please ensure that all fields are filled", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func allFieldsFilled() -> Bool{
        for field in stepTexts {
            if (field.text == ""){
                return false
            }
        }
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pivot = noBranchLbl.frame.origin.y
        screenWidth = self.view.frame.size.width
        // Do any additional setup after loading the view.
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
