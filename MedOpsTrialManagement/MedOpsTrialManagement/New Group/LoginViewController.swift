//
//  LoginViewController.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-11-27.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let backend = "http://192.168.0.108:3000/auth/login"
    let FAILED_LOGIN = "FAILED_LOGIN"
    
    @IBOutlet weak var messageLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onLogin(_ sender: Any) {
        let user = LoginUser(e: usernameField.text!, p: passwordField.text!)
        authenticate(user: user, handler: {result in
            if result == self.FAILED_LOGIN {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Login Failure", message: "Failed to login. Please check that your credentials are valid", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {action in
                        self.handlePostLogin(jwt: result)
                    }))
                    
                    self.present(alert, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.handlePostLogin(jwt: result)
                }
            }
        })
    }
    
    func handlePostLogin(jwt: String){
        UserDefaults.standard.setValue(jwt, forKey: "JWT")
        
        if let token = UserDefaults.standard.value(forKey: "JWT") as? String {
            print(token)
            print("Key was successfully saved")
            performSegue(withIdentifier: "showTrials", sender: self)
        } else {
            //
        }
        
    }
    
    func authenticate(user: LoginUser, handler: @escaping (String) -> Void){
        let urlComp = URLComponents(string: backend)
        let body = [
            "email": user.email,
            "password": user.password
        ]
        
        var request = URLRequest(url: (urlComp?.url)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if(error != nil || data == nil) {
                handler(self.FAILED_LOGIN)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode != 200){
                    handler(self.FAILED_LOGIN)
                    return
                }
            }
            print(response)
            print(data)
            
            do {
                let token = String(data: data!, encoding: String.Encoding.utf8)
                print(token!)
                handler(token!)
                
            } catch let parsingerror{
                print(parsingerror)
                handler(self.FAILED_LOGIN)
            }
        }
        
        task.resume()
        
    }
    
}
