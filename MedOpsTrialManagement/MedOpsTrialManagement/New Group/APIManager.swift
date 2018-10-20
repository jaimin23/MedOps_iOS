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
        //let urlString: String = "http://192.168.0.107:32768/api/trial/"
        var parsedTrialData : [Trial] = []
        var usersList : [User] = []
        
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
                    guard let users = trial["userTrials"] as? [[String: Any]] else {return}
                    for user in users{
                        let uData = user["user"] as? [String: Any]
                        let firstName = uData?["firstName"] as? String
                        let lastName = uData?["lastName"] as? String
                        let userType = uData?["userType"] as? Int
                        let uniqueId = uData?["userUniqueId"] as? String
                        let applicationStatus = uData?["status"] as? Int
                        let address = uData?["address"] as? String
                        let ethnicity = uData?["ethnicity"] as? String
                        let age = uData?["age"] as? Int
                        let email = uData?["email"] as? String
                        let password = uData?["password"] as? String
                        let newUser = User(firstName: firstName ?? "",
                                           lastName: lastName ?? "",
                                           userType: userType ?? 0,
                                           userUniqueId: uniqueId ?? "",
                                           status: applicationStatus ?? 0,
                                           email: email ?? "",
                                           address: address ?? "",
                                           ethnicity: ethnicity ?? "",
                                           age: age ?? 0,
                                           password: password ?? "")
                        usersList.append(newUser)
                    }
                    let newTrial = Trial(name: title, completed: completed, id: id, users:usersList)
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
    
    func postQuestion(question: Question, completion:((Error?) -> Void)?){
        
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
            completion?(error)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: postRequest) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion?(responseError!)
                return
            }
            print("printing response")
            print(responseData!)
            print(response!)
            print(responseError!)
            
        }
        task.resume()
    }
    
    func selectPatients(patients: [User], completion:((Error?) -> Void)?){
        let urlString: String = "{}}/api/user/patients/"
        let requestString = URL(string: urlString)
        // Create Request
        var postRequest = URLRequest(url: requestString!)
        
        postRequest.httpMethod = "PATCH"
        
        
        var headers = postRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        postRequest.allHTTPHeaderFields = headers
        var parameters = [[String: AnyObject]]()
        var data = [String: AnyObject]()
        for patient in patients {
            data["userUniqueId"] = patient.userUniqueId as AnyObject
            data["status"] = patient.status as AnyObject
            data["firstName"] = patient.firstName as AnyObject
            data["lastName"] = patient.lastName as AnyObject
            data["email"] = patient.email as AnyObject
            data["password"] = patient.password as AnyObject
            data["address"] = patient.address as AnyObject
            data["userType"] = patient.userType as AnyObject
            data["ethnicity"] = patient.ethnicity as AnyObject
            data["age"] = patient.age as AnyObject
            parameters.append(data)
        }
        
        
    
        postRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: postRequest) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion?(responseError!)
                return
            }
            print("printing response")
            print(responseData)
            print(response)
            print(responseError)
            
        }
        task.resume()
        
    }
}
