//
//  RegistrationController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-28.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    let registrationAPI = "http://167.99.231.175/auth/register"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onRegister(_ sender: Any) {
        let password = passwordField.text
        let confirmedPassword = confirmPasswordField.text
        
        // Make sure tht the user has properly confirmed their password
        if password != confirmedPassword {
            let alert = UIAlertController(title: "Password Mismatch", message: "The passwords do not match. Please ensure that they are properly typed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true)
        }
        
        // Gather the details and build the data transfer object
        let firstName = firstNameField.text
        let lastName = lastNameField.text
        let email = emailField.text
        
        let pi = PIRegistration(email: email!, pass: password!, first: firstName!, last: lastName!)
        
        registration(user: pi, handler: {result in
            
            DispatchQueue.main.async {
                if (result){
                    let alert = UIAlertController(title: "Registration Success", message: "Successfully registered! Redirecting your login.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Registration Error", message: "There was an error with your registration. Please notify the admins", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        })
    }
    
    func registration(user: PIRegistration, handler: @escaping (Bool) -> Void) {
        let urlComp = URLComponents(string: registrationAPI)
        var request = URLRequest(url: (urlComp?.url)!)
        
        let body = [
            "email": user.email,
            "password": user.password,
            "firstName": user.firstName,
            "astName": user.lastName
        ]
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if(error != nil || data == nil) {
                handler(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode != 200){
                    handler(false)
                    return
                }
            }
            print(response)
            print(data)
            
            do {
                let token = String(data: data!, encoding: String.Encoding.utf8)
                print(token!)
                handler(true)
                
            } catch let parsingerror{
                print(parsingerror)
                handler(false)
            }
        }
        
        task.resume()
        
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
