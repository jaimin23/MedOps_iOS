//
//  APIManager.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-03.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation


class APIManager {
    let cloudDomain: String = "https://medopscloud.azurewebsites.net"
    
    func getTrials(completion: @escaping (_ trialData: [Trial]) -> ()){
        var urlString : String = "http://167.99.231.175/api/trial/"
        //let urlString: String = "{}/api/trial/"
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
                    var usersList : [User] = []
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
                    print(newTrial.users.count)
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
        //var url = URLComponents()
//        url.scheme = "https"
//        url.host = "medopscloud.azurewebsites.net"
//        url.scheme = "http"
//        url.host = "192.168.0.107:32771"
//        url.path = "/api/trial/question/"
        
        //guard let urlString = url.url else {fatalError("Unable to make url from string")}
        let urlString: String = "http://192.168.0.107:32770/api/trial/question/"
        let requestString = URL(string: urlString)
        // Create Request
        var postRequest = URLRequest(url: requestString!)
        
        postRequest.httpMethod = "POST"
        
        // TODO delete debug statement
        //print(urlString.absoluteString)
        
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
            print(responseData!)
            print(response!)
            
        }
        task.resume()
    }
    
    func selectPatients(patients: [User], completion:((Error?) -> Void)?){
        let urlString: String = "https://medopscloud.azurewebsites.net/api/user/patients/"
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
    
    func getTrialEvaluations(trialId: Int, onComplete evalData: @escaping (_ evalData: [Evaluation]) -> Void){
        let urlString = cloudDomain + "/api/data/completed?trialId=\(trialId)"
        
        print(urlString)
        
        var parsedEvalData : [Evaluation] = []
        
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
                
                print(jsonArray)
                for eval in jsonArray {
                    guard let id = eval["id"] as? Int else {return}
                    guard let date = eval["date"] as? String else {return}
            
                    
                    let evaluation : Evaluation = Evaluation(id: id, date: date, name: "user")
                    
                    parsedEvalData.append(evaluation)
                }
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            evalData(parsedEvalData)
            
        }
        
        task.resume()
    }
}

