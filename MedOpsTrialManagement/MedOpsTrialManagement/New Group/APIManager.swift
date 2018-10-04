//
//  APIManager.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-03.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation


class APIManager {
    var urlString : String = "https://medopscloud.azurewebsites.net/api/trial/"
    
    
    func getTrials(completion: @escaping (_ trialData: [Trial]) -> ()){
        var parsedTrialData : [Trial] = []
        
        
        let requestString = URL(string: urlString)
        
        let request = URLRequest(url: requestString!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
            guard let dataRes = data, error == nil else {
                // handle error
                return
            }
            
            do {
                let jsonRes = try JSONSerialization.jsonObject(with: dataRes, options: [])
                
                guard let jsonArray = jsonRes as? [[String: Any]] else {
                    return
                }
                
                for trial in jsonArray {
                    guard let title = trial["name"] as? String else {return}
                    guard let completed = trial["completed"] as? Bool else {return}
                    
                    
                    let newTrial = Trial(name: title, completed: completed)
                    parsedTrialData.append(newTrial)
                    print("Trial Details")
                    print(title)
                }

                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            completion(parsedTrialData)
            
        }
        
        task.resume()
    }
}
