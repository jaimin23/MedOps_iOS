//
//  ViewController.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-04-22.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userPassTxtField: UITextField!
    @IBOutlet weak var userIdTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Code used from
        //Setup a tap gesture which will dismiss the keyboard when done editing the text fields
        let tap = (UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logInBtnPressed(_ sender: Any){
        if(userIdTxtField.text != "" && userPassTxtField.text != ""){
            if(userIdTxtField.text == "admin" && userPassTxtField.text == "password"){
                let trialMainPage = storyboard?.instantiateViewController(withIdentifier: "TrialMainPage")
                self.present(trialMainPage!,animated:true,completion: nil)
            }
        }else{
            self.alertBox(title: "Log In Failed", message: "User Name or Password Not Found. Please Try Again!")
        }
    }
    
    private func alertBox(title: String, message: String){
        let alertBox = UIAlertController(title: "Log In Failed", message: "User Name or Password Not Found. Please Try Again!", preferredStyle: UIAlertControllerStyle.alert)
        alertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("Default")
            case.cancel:
                print("Cancel")
            case.destructive:
                print("Distructive")
            }
        }))
        self.present(alertBox,animated: true,completion: nil)
    }
    
}

