//
//  APIManager.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-03.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation


class APIManager {
    let cloudDomain: String = "medopscloud.azurewebsites.net"
    
    func getTrials(completion: @escaping (_ trialData: [Trial]) -> ()){
        var urlString : String = "https://medopscloud.azurewebsites.net/api/trial/"
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
                    guard let id = trial["trialId"] as? Int else {return}
                    
                    
                    let newTrial = Trial(name: title, completed: completed, id: id)
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
    
    func postQuestion(question: Question, onComplete isSuccess: @escaping (_ result: Bool) -> Void){
        
        // Create URL
        var url = URLComponents()
        url.scheme = "https"
        url.host = cloudDomain
        url.path = "/api/trial/question/"
        
        guard let urlString = url.url else {fatalError("Unable to make url from string")}
        
        // Create Request
        var postRequest = URLRequest(url: urlString)
        
        postRequest.httpMethod = "POST"
        
        // TODO delete debug statement
        print(urlString.absoluteString)
        
        var headers = postRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        postRequest.allHTTPHeaderFields = headers
        
        // Serialize question to JSON
        let jsonEncoder = JSONEncoder()
        do {
            let postData =  try jsonEncoder.encode(question)
            print(postData)
            postRequest.httpBody = postData
        } catch {
            // TODO error handle
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: postRequest) { (responseData, response, responseError) in
            guard responseError == nil else {
                // TODO error handle
                return
            }
            print("printing response")
            print(responseData)
            print(response)
            print(responseError)
            
            isSuccess(true)
        }
        task.resume()
    }
}
