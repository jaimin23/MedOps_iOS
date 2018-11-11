//
//  APIManager.swift
//  MedOpsTrialManagement
//
//  Created by Xcode User on 2018-10-03.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation


class APIManager {
    let scheme : String
    let domain : String
    let cloudDomain: String
    
    init(){
        scheme = "http"
        domain = "167.99.231.175"
        cloudDomain = self.scheme + "://" + self.domain
    }
    
    func getTrials(completion: @escaping (_ trialData: [Trial]) -> ()){
        let urlString : String = "http://167.99.231.175/api/trial/"
        //let urlString: String = "{}/api/trial/"
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
                    guard let status = trial["status"] as? Int else {return}
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
                    let newTrial = Trial(name: title, completed: completed, id: id, users:usersList, status: status)
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
    
    func getQuestions(trialId: Int, onComplete questions: @escaping (_ questions: [Question]) -> Void){
        let urlString: String = cloudDomain + "/api/trial/question?trialId=" + String(trialId)
        var parsedQuestionData : [Question] = []
        
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
                for question in jsonArray {
                    guard let text = question["text"] as? String else {return}
                    guard let questionType = question["questionType"] as? Int else {return}
                    
                    let question = Question(text: text, questionType: questionType, trialId: trialId)
                    //TODO add questions
                    parsedQuestionData.append(question)
                    
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            questions(parsedQuestionData)
        }
        
        task.resume()
        
    }
    
    func getBranches(trialId: Int, onComplete branches: @escaping (_ branches: [Branch]) -> Void){
        let urlString : String = cloudDomain + "/api/trial/branch?trialId=\(trialId)"
        
        var parsedData : [Branch] = []
        
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
                for branches in jsonArray {
                    // Cycle and parse the branch
                    guard let text = branches["hypothesis"] as? String else {return}
                    guard let steps = branches["steps"] as? [[String: Any]] else {return}
                    guard let id = branches["id"] as? Int else {return}
                    
                    
                    // Cycle and parse the steps in the branch
                    var branchSteps : [Step] = []
                    
                    for step in steps{
                        guard let summary = step["summary"] as? String else {return}
                        guard let stepNumber = step["stepNumber"] as? Int else {return}
                        guard let stepId = step["stepID"] as? Int else {return}
                        
                        let newStep = Step(id: stepId, summary: summary, stepNumber: stepNumber)
                        branchSteps.append(newStep)
                    }
                    
                    let newBranch = Branch(id: id, hyp: text, steps: branchSteps)
                    
                    parsedData.append(newBranch)
                    
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            branches(parsedData)
        }
        
        task.resume()
    }
    
    func postQuestion(question: Question, onComplete isSuccess: @escaping (_ result: Bool) -> Void){
        
        // Create URL
        var url = URLComponents()
        url.scheme = "http"
        url.host = "167.99.231.175"
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
            print(responseData!)
            print(response!)
            
            isSuccess(true)
            
        }
        task.resume()
    }
    
    func selectPatients(patients: [User], completion:((Error?) -> Void)?){
        let urlString: String = "http://167.99.231.175/api/user/patients/"
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
    
    func StartTrial(trialId: Int, onComplete saved: @escaping (_ saved: Bool) -> Void){
        // Create URL
//        var url = URLComponents()
//        url.scheme = self.scheme
//        url.host = self.domain
//        url.path = "c
        
        let urlString: String = "http://167.99.231.175/api/trial/begin?trialId="+String(trialId)
        let requestString = URL(string: urlString)
        
//        guard let urlString = url.url else {fatalError("Unable to make url from string")}
        
        // Create Request
        var postRequest = URLRequest(url: requestString!)
        
        postRequest.httpMethod = "POST"
        
        // TODO delete debug statement
//        print(urlString.absoluteString)
        
        var headers = postRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        postRequest.allHTTPHeaderFields = headers
        
        // Serialize question to JSON
        
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
            saved(true)
            
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
                    guard let encodedData = eval["encodedImage"] as? String else {return}
            
                    if let decodedData = Data(base64Encoded: encodedData, options: .ignoreUnknownCharacters) {
                        let evaluation : Evaluation = Evaluation(id: id, date: date, name: "user", image: decodedData)
                        parsedEvalData.append(evaluation)
                    }
                    
                    
            
                }
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            evalData(parsedEvalData)
            
        }
        
        task.resume()
    }
    
    func getDiseases(completion: @escaping (_ diseases: [Diseases]) -> ()){
        let urlString : String = self.cloudDomain + "/api/data/disease"
        var parsedDiseases : [Diseases] = []
        
        
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
                
                for disease in jsonArray {
                    guard let name = disease["name"] as? String else {return}
                    guard let diseaseId = disease["diseaseId"] as? Int else {return}
                    
                    
                    let newDisease = Diseases(name: name, diseaseId: diseaseId)
                    parsedDiseases.append(newDisease)
                    print("Disease")
                    print(name)
                }
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            completion(parsedDiseases)
            
        }
        
        task.resume()
    }
    
    func createTrial(trial: TrialModel, completion:((Error?) -> Void)?){
        var urlComponent = URLComponents()
        urlComponent.scheme = self.scheme
        urlComponent.host = self.domain
        urlComponent.path = "/api/trial"
        guard let url = urlComponent.url else{
            fatalError("Could not create url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        do{
            let jsonData = try encoder.encode(trial)
            request.httpBody = jsonData
        } catch{
            completion?(error)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request){(responseData, response, responseError) in
            guard responseError == nil else{
                completion?(responseError!)
                return
            }
            print(responseData)
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8){
                print("Response", utf8Representation)
            }else{
                print("no data recieved")
            }
        }
        task.resume()
    }
}

