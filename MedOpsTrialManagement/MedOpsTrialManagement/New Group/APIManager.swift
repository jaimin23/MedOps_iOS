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
    let port: String
    
    init(){
        scheme = "http"
        domain = "167.99.231.175"
        port = "5000"
        cloudDomain = self.scheme + "://" + self.domain + ":" + self.port
        //cloudDomain = self.scheme + "://" + self.domain
    }
    
    func getTrials(completion: @escaping (_ trialData: [Trial]) -> ()){
//        let urlString : String = "\(scheme)://\(domain):\(port)/api/trial/pitrials"
        let urlString : String = "\(scheme)://\(domain):\(port)/api/trial/pitrials"

        //let urlString: String = "{}/api/trial/"
        var parsedTrialData : [Trial] = []
        let steps: [Step] = []
        
        let requestString = URL(string: urlString)
        
        var request = URLRequest(url: requestString!)
        
        if let token = UserDefaults.standard.value(forKey: "JWT") as? String {
            print("Key was successfully saved")
            let tokenString = "Bearer \(token)"
            request.addValue(tokenString, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            completion([])
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
            guard let dataRes = data, error == nil else {
                // handle error
                print(error)
                return
            }
            if let httpResponse = res as? HTTPURLResponse {
                print("Code \(httpResponse.statusCode)")
            }
            
            do {
                let jsonRes = try JSONSerialization.jsonObject(with: dataRes, options: [])
                
                guard let jsonArray = jsonRes as? [[String: Any]] else {
                    return
                }
                for trial in jsonArray {
                    var usersList : [User] = []
                    var branchList: [Branch] = []
                    guard let title = trial["name"] as? String else {return}
                    guard let completed = trial["completed"] as? Bool else {return}
                    guard let id = trial["trialId"] as? Int else {return}
                    guard let status = trial["status"] as? Int else {return}
                    guard let startDate = trial["startDate"] as? String else{return}
                    guard let targetEndDate = trial["targetEndDate"] as? String else{return}
                    guard let stats = trial["stats"] as? [String: Any] else {return}
                    
                    
                    guard let branchCount = stats["branchCount"] as? Int else {return}
                    guard let completedCount = stats["completedEvaluationCount"] as? Int else {return}
                    guard let expectedCount = stats["expectedEvaluationCount"] as? Int else {return}
                    // build trial stats
                    let branches = trial["branches"] as? [[String: Any]]
//                    for user in users{
//                        let uData = user["user"] as? [String: Any]
//                        let id = uData?["userId"] as? Int
//                        let firstName = uData?["firstName"] as? String
//                        let lastName = uData?["lastName"] as? String
//                        let userType = uData?["userType"] as? Int
//                        let uniqueId = uData?["userUniqueId"] as? String
//                        let applicationStatus = uData?["applicationStatus"] as? Int
//                        let address = uData?["address"] as? String
//                        let ethnicity = uData?["ethnicity"] as? Int
//                        let gender = uData?["gender"] as? Int
//                        let age = uData?["age"] as? Int
//                        let email = uData?["email"] as? String
//                        let password = uData?["password"] as? String
//                        let newUser = User(id: id ?? 0,
//                                            firstName: firstName ?? "",
//                                           lastName: lastName ?? "",
//                                           userType: userType ?? 0,
//                                           userUniqueId: uniqueId ?? "",
//                                           status: applicationStatus ?? 0,
//                                           email: email ?? "",
//                                           address: address ?? "",
//                                           ethnicity: ethnicity ?? 0,
//                                           age: age ?? 0,
//                                           password: password ?? "",
//                                           gender: gender ?? 0)
//                        usersList.append(newUser)
//                    }
                    for branch in branches ?? []{
                        guard let id = branch["id"] as? Int else{return}
                        guard let hypothesis = branch["hypothesis"] as? String else{return}
                        guard let trialId = branch["trialId"] as? Int else{return}
                        let newBranch = Branch(id: id, hyp: hypothesis, steps: steps, trialId: trialId)
                        branchList.append(newBranch)
                    }
                    let newTrial = Trial(name: title, completed: completed, id: id, users:usersList, status: status,
                                         branches: branchList, startDate: startDate, targetEndDate: targetEndDate)
                    newTrial.stats = TrialStats(branch: branchCount, evals: completedCount, totalEvals: expectedCount)
                    parsedTrialData.append(newTrial)
                    
                }

                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            completion(parsedTrialData)
            
        }
        
        task.resume()
    }
    
    func getQuestionnaires(trialId: Int, onComplete questionnaires: @escaping (_ questions: [Questionnaire]) -> Void){
        let urlString: String = cloudDomain + "/api/questionnaire/trialQuestionnaires?trialId=" + String(trialId)
        var parsedQuestionnaires : [Questionnaire] = []
        
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
                for questionnaire in jsonArray {
                   
                    guard let title = questionnaire["title"] as? String else {return}
                    guard let id = questionnaire["questionnaireId"] as? Int else {return}
                    
                    // Todo populate
                    let q = Questionnaire(id: id, title: title, questions: [], trialId: trialId)
                    parsedQuestionnaires.append(q)
                    
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            questionnaires(parsedQuestionnaires)
        }
        
        task.resume()
        
    }
    
    func postQuestionnaire(questionnaire: Questionnaire, onComplete returnedValues: @escaping (_ returnedQuestionnaire: Bool) -> Void){
        var url = URLComponents()
        url.scheme = scheme
        url.host = domain
        url.port = Int(port)
        url.path = "/api/questionnaire/add/"
        
        guard let urlString = url.url else {fatalError("Unable to create url from string")}
        
        // Create Request
        var postRequest = URLRequest(url: urlString)
        
        postRequest.httpMethod = "POST"
        
        var headers = postRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        postRequest.allHTTPHeaderFields = headers
        
        // Serialize question to JSON
        let jsonEncoder = JSONEncoder()
        do {
            let postData =  try jsonEncoder.encode(questionnaire)
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
            
            guard let data = responseData else {return}
            
            do {
                print(responseData!)
                print(response!)

                returnedValues(true)
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
//    func getQuestions(questionnaireId: Int, onComplete questions: @escaping (_ questions: [Question]) -> Void){
//        let urlString: String = cloudDomain + "/api/trial/question?trialId=" + String(questionnaireId)
//        var parsedQuestionData : [Question] = []
//
//        let requestString = URL(string: urlString)
//
//        let request = URLRequest(url: requestString!)
//
//        let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
//            guard let dataRes = data, error == nil else {
//                // handle error
//                return
//            }
//            do {
//                let jsonRes = try JSONSerialization.jsonObject(with: dataRes, options: [])
//                guard let jsonArray = jsonRes as? [[String: Any]] else {
//                    return
//                }
//                for question in jsonArray {
//                    guard let text = question["text"] as? String else {return}
//                    guard let questionType = question["questionType"] as? Int else {return}
//                    guard let questionPhase = question["questionPhase"] as? Int else {return}
//
//                    let question = Question(text: text, questionType: questionType, questionnaireId: questionnaireId, questionPhase: questionPhase)
//                    //TODO add questions
//                    parsedQuestionData.append(question)
//
//                }
//            } catch let parsingError {
//                print("Error", parsingError)
//            }
//
//            questions(parsedQuestionData)
//        }
//
//        task.resume()
//
//    }
    
    func getTrialPatients(trialId: Int, onComplete patients: @escaping (_ patients: [UserTrials]) -> Void){
        
        let urlString : String = "\(scheme)://\(domain)/api/user/trialUsers?trialId=\(trialId)"
        //let urlString: String = "{}/api/trial/"
        var parsedTrialData : [UserTrials] = []
        
        
        let requestString = URL(string: urlString)
        
        var request = URLRequest(url: requestString!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
            guard let dataRes = data, error == nil else {
                // handle error
                return
            }
            if let httpResponse = res as? HTTPURLResponse {
                print("Code \(httpResponse.statusCode)")
            }
            
            do {
                let jsonRes = try JSONSerialization.jsonObject(with: dataRes, options: [])
                
                guard let jsonArray = jsonRes as? [[String: Any]] else {
                    return
                }
                for uts in jsonArray {
                    guard let approved = uts["isApproved"] as? Bool else {return}

                    
                    guard let uData = uts["user"] as? [String: Any] else {return}

                    let id = uData["userId"] as? Int
                    let firstName = uData["firstName"] as? String

                    let lastName = uData["lastName"] as? String ?? ""

                    let userType = uData["userType"] as? Int
                    let uniqueId = ""
                    let applicationStatus = uData["applicationStatus"] as? Int
                    let address = uData["address"] as? String ?? ""
                    let ethnicity = uData["ethnicity"] as? Int
                    let gender = uData["gender"] as? Int
                    let age = uData["age"] as? Int
                    let email = uData["email"] as? String
                    let password = ""
                    let newUser = User(id: id!, firstName: firstName!, lastName: lastName, userType: userType!, userUniqueId: uniqueId, status: applicationStatus!, email: email!, address: address, ethnicity: ethnicity!, age: age!, password: password, gender: gender!)
//                                            let newUser = User(id: id ?? 0,
//                                                                firstName: firstName ?? "",
//                                                               lastName: lastName ?? "",
//                                                               userType: userType ?? 0,
//                                                               userUniqueId: uniqueId ?? "",
//                                                               status: applicationStatus ?? 0,
//                                                               email: email ?? "",
//                                                               address: address ?? "",
//                                                               ethnicity: ethnicity ?? "",
//                                                               age: age ?? 0,
//                                                               password: password ?? "")
                    let ut = UserTrials(p: newUser, approved:  approved)
                    parsedTrialData.append(ut)
                    
                }
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            patients(parsedTrialData)
            
        }
        
        task.resume()
        

        
    }
    
    func getQuestions(questionnaireId: Int, onComplete questions: @escaping (_ questions: [Question]) -> Void){
        let urlString: String = cloudDomain + "/api/trial/question?trialId=" + String(questionnaireId)
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
                    guard let id = question["id"] as? Int else {return}
                    guard let questionType = question["questionType"] as? Int else {return}
                    guard let questionPhase = question["questionPhase"] as? Int else {return}
                    
                    
                    let q = Question(id: id, text: text, questionType: questionType, questionnaireId: questionnaireId, questionPhase: questionPhase)
                    
                    parsedQuestionData.append(q)
                    
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
                        guard let questionnaireId = step["questionnaireId"] as? Int else {return}
                        
                        let newStep = Step(id: stepId, summary: summary, stepNumber: stepNumber, questionnaireId: questionnaireId)
                        branchSteps.append(newStep)
                    }
                    
                    let newBranch = Branch(id: id, hyp: text, steps: branchSteps, trialId: trialId)
                    
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
        url.scheme = scheme
        url.host = domain
        url.port = Int(port)
        url.path = "/api/trial/question/"
        
        guard let urlString = url.url else {fatalError("Unable to make url from string")}
        
        // Create Request
        var postRequest = URLRequest(url: urlString)
        
        postRequest.httpMethod = "POST"
        
        var headers = postRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        postRequest.allHTTPHeaderFields = headers
        
        // Serialize question to JSON
        let jsonEncoder = JSONEncoder()
        do {
            let postData =  try jsonEncoder.encode(question)
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
    
    func postBranch(branch: Branch, onComplete isSuccess: @escaping (_ result: Bool) -> Void){
        
        // Create URL
        var url = URLComponents()
        url.scheme = scheme
        url.host = domain
        url.port = Int(port)
        url.path = "/api/trial/branch/"
        
        guard let urlString = url.url else {fatalError("Unable to create url from string")}
        
        // Create Request
        var postRequest = URLRequest(url: urlString)
        
        postRequest.httpMethod = "POST"
        
        var headers = postRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        postRequest.allHTTPHeaderFields = headers
        
        // Serialize question to JSON
        let jsonEncoder = JSONEncoder()
        do {
            let postData =  try jsonEncoder.encode(branch)
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
    
    func approvePatient(patientId : Int, branchId: Int, onComplete isSuccess: @escaping (_ result: Bool) -> Void){
        // Create URL
        var url = URLComponents()
        url.scheme = scheme
        url.host = domain
        url.port = Int(port)
        url.path = "/api/user/approve"
        
        guard let urlString = url.url else {fatalError("Unable to create url from string")}
        
        // Create Request
        var postRequest = URLRequest(url: urlString)
        
        postRequest.httpMethod = "POST"
        
        var headers = postRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        postRequest.allHTTPHeaderFields = headers
        
        // Serialize question to JSON
        let jsonEncoder = JSONEncoder()
        do {
            let json: [String: Any] = ["patientId": patientId, "branchId": branchId]
            let postData =  try? JSONSerialization.data(withJSONObject: json)
            postRequest.httpBody = postData
            
            if let string = String(data: postData!, encoding: String.Encoding.utf8) {
                print(string)
            }
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
        let urlString: String = "\(scheme)://\(domain):\(port)/api/user/patients/"
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
        
        let urlString: String = cloudDomain+"/api/trial/begin?trialId=\(trialId)"
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
    func completeTrial(trialId: Int, onComplete saved: @escaping (_ saved: Bool) -> Void){
        // Create URL
        //        var url = URLComponents()
        //        url.scheme = self.scheme
        //        url.host = self.domain
        //        url.path = "c
        
        let urlString: String = cloudDomain+"/api/trial/complete?trialId=\(trialId)"
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
                
                for eval in jsonArray {
                    guard let id = eval["id"] as? Int else {return}
                    guard let date = eval["date"] as? String else {return}
                    guard let encodedData = eval["encodedImage"] as? String else {return}
                    
                    guard let pResponses = eval["patientResponses"] as? [[String: Any]] else {return}
                    
                    var responseList : [PatientResponse] = []
                    
                    for res in pResponses{
                        guard let question = res["question"] as? [String:Any] else {return}
                        guard let questionText = question["text"] as? String else {return}
                        guard let answerText = res["response"] as? String else {return}
                        
                        responseList.append(PatientResponse(q: questionText, a: answerText))
                        
                        
                    }
                        
                        
            
                    if let decodedData = Data(base64Encoded: encodedData, options: .ignoreUnknownCharacters) {
                        let evaluation : Evaluation = Evaluation(id: id, date: date, name: "user", image: decodedData, res: responseList)
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
    
    func getPatientEvaluations(patientId: Int, trialId: Int, onComplete evalData: @escaping (_ evalData: EvaluationProfile) -> Void){
        let urlString = cloudDomain + "/api/data/patientEvaluations?patientId=\(patientId)&trialId=\(trialId)"
        
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
                
                guard let profileJsonData = jsonRes as? [String: Any] else {
                    return
                }
                
                guard let eProfile = profileJsonData["evaluations"] as? [[String: Any]] else {
                    return
                }
                
                guard let active = profileJsonData["active"] as? Bool else {return}
                
                guard let uData = profileJsonData["user"] as? [String: Any] else {return}
                
                guard let branch = profileJsonData["branch"] as? [String: Any] else {return}
                
                guard let stepNumber = profileJsonData["currentStepNumber"] as? Int else {return}
                
                guard let steps = branch["steps"] as? [[String: Any]] else {return}

            
                
                
                // Load user data
                
                let id = uData["userId"] as? Int
                let firstName = uData["firstName"] as? String
                let lastName = uData["lastName"] as? String
                let userType = uData["userType"] as? Int
                let uniqueId = ""
                let applicationStatus = uData["applicationStatus"] as? Int
                let address = uData["address"] as? String
                let ethnicity = uData["ethnicity"] as? Int
                let gender = uData["gender"] as? Int
                let age = uData["age"] as? Int
                let email = uData["email"] as? String
                let password = ""
                let newUser = User(id: id!, firstName: firstName!, lastName: lastName!, userType: userType!, userUniqueId: uniqueId, status: applicationStatus!, email: email!, address: address!, ethnicity: ethnicity!, age: age!, password: password, gender: gender!)
                
                
                // load eval data
                
                for eval in eProfile{
                    guard let id = eval["id"] as? Int else {return}
                    guard let date = eval["date"] as? String else {return}
                    guard let encodedData = eval["encodedImage"] as? String else {return}
                    
                    guard let pResponses = eval["patientResponses"] as? [[String: Any]] else {return}
                    
                    var responseList : [PatientResponse] = []
                    
                    for res in pResponses{
                        print(res)
                        guard let question = res["question"] as? [String:Any] else {return}
                        guard let questionText = question["text"] as? String else {return}
                        guard let answerText = res["response"] as? String else {return}
                        
                        responseList.append(PatientResponse(q: questionText, a: answerText))
                        
                        
                    }
                    
                    if let decodedData = Data(base64Encoded: encodedData, options: .ignoreUnknownCharacters) {
                        let evaluation : Evaluation = Evaluation(id: id, date: date, name: "user", image: decodedData, res: responseList)
                        parsedEvalData.append(evaluation)
                    }
                    
                
                    
                    
                    
                }
                
                // Load branch data
                
                guard let text = branch["hypothesis"] as? String else {return}
        
                guard let branchId = branch["id"] as? Int else {return}
                
                // Cycle and parse the steps in the branch
                var branchSteps : [Step] = []
                
                for step in steps{
                    guard let summary = step["summary"] as? String else {return}
                    guard let stepNumber = step["stepNumber"] as? Int else {return}
                    guard let stepId = step["stepID"] as? Int else {return}
                    guard let questionnaireId = step["questionnaireId"] as? Int else {return}
                    
                    let newStep = Step(id: stepId, summary: summary, stepNumber: stepNumber, questionnaireId: questionnaireId)
                    branchSteps.append(newStep)
                }
                
                
                let branchObject = Branch(id: branchId, hyp: text, steps: branchSteps, trialId: id!)
                
                let evaluationProfile = EvaluationProfile(p: newUser, e: parsedEvalData, b: branchObject, a: active, st: stepNumber)
                
                evalData(evaluationProfile)
                
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            
        }
        
        task.resume()
    }
    
    func createTrial(trial: TrialModel, onComplete saved: @escaping (_ saved: Bool) -> Void){
        var urlComponent = URLComponents()
        urlComponent.scheme = self.scheme
        urlComponent.host = self.domain
        urlComponent.port = Int(self.port)
        urlComponent.path = "/api/trial"
        guard let url = urlComponent.url else{
            fatalError("Could not create url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        
        if let token = UserDefaults.standard.value(forKey: "JWT") as? String {
            headers["Authorization"] = "Bearer \(token)"
        } else {
            // todo handle
        }
        request.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        do{
            let jsonData = try encoder.encode(trial)
            print(jsonData)
            request.httpBody = jsonData
        } catch{
            print(error)
            saved(false)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request){(responseData, response, responseError) in
            guard responseError == nil else{
                print(responseError!)
                saved(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Code \(httpResponse.statusCode)")
            }
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8){
                print("Response", utf8Representation)
                saved(true)
            }else{
                print("no data recieved")
            }
        }
        task.resume()
    }
    
    func registerNurse(user: PIRegistration, trialId: Int, handler: @escaping (Bool) -> Void) {
        let apiUrl = "\(cloudDomain)/auth/registernurse"
        
        let urlComp = URLComponents(string: apiUrl)
        var request = URLRequest(url: (urlComp?.url)!)
        
        let body = [
            "email": user.email,
            "password": user.password,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "trialId": trialId
            ] as [String : Any]
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
                    print(response)
                    print(data)
                    return
                }
            }

            

        }
        
        task.resume()
        
    }
    
    func getBranchesWithQuestionnaire(trialId: Int, onComplete questions: @escaping (_ questions: [Question]) -> Void){
        let urlString : String = cloudDomain + "/api/trial/branch?trialId=\(trialId)"
        let requestString = URL(string: urlString)
        var questionList: [Question] = []
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
                    guard let steps = branches["steps"] as? [[String: Any]] else {return}
                    for step in steps{
                        guard let questionnaire = step["questionnaire"] as? [String:Any] else {return}
                        guard let questions = questionnaire["questions"] as? [[String:Any]] else {return}
                        for question in questions{
                            guard let text = question["text"] as? String else {return}
                            guard let answers = question["answers"] as? [[String: Any]] else {return}
                            var answersList: [Answer] = []
                            for answer in answers{
                                guard let value = answer["value"] as? String else{return}
                                let newAnswer = Answer(value: value)
                                answersList.append(newAnswer)
                            }
                            var newQuestion = Question(text: text, questionType: 0, questionnaireId: 0, questionPhase: 0)
                            newQuestion.answers = answersList
                            questionList.append(newQuestion)
                        }
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            questions(questionList)
        }
        
        task.resume()
    }
    
    //This API call only extracts some information for evaluation
    func getPatientEvaluationsForGraph(trialId: Int, onComplete evalData: @escaping (_ evalData: [EvalData]) -> Void){
        let urlString = cloudDomain + "/api/data/completed?trialId=\(trialId)"
        var parsedEvalData : [EvalData] = []
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
                for eval in jsonArray {
                    guard let patientInfo = eval["patient"] as? [String: Any] else{return}
                    guard let age = patientInfo["age"] as? Int else{return}
                    guard let gender = patientInfo["gender"] as? Int else{return}
                    guard let pResponses = eval["patientResponses"] as? [[String: Any]] else {return}
                    for res in pResponses{
                        var questionText = ""
                        var response = ""
                        guard let question = res["question"] as? [String:Any] else {return}
                        questionText = question["text"] as? String ?? ""
                        response = res["response"] as? String ?? ""
                        let newEvals = EvalData(quetion: questionText, answer: response, age: age, gender: gender)
                        parsedEvalData.append(newEvals)
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            evalData(parsedEvalData)
            
        }
        
        task.resume()
    }
    
    func getAllUsersByTrial(trialId: Int, onComplete users: @escaping (_ users: [User]) -> Void){
        let urlString: String = cloudDomain + "/api/user/usersByTrial?trialId=\(trialId)"
        var userList : [User] = []
        
        let requestString = URL(string: urlString)
        
        let request = URLRequest(url: requestString!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, res, error) in
            guard let dataRes = data, error == nil else {
                // handle error
                return
            }
            do {
                let jsonRes = try JSONSerialization.jsonObject(with: dataRes, options: [])
                guard let jsonObj = jsonRes as? [[String: Any]] else {
                    return
                }
                for users in jsonObj{
                    let uData = users["user"] as? [String: Any]
                    let id = uData?["userId"] as? Int
                    let firstName = uData?["firstName"] as? String
                    let lastName = uData?["lastName"] as? String
                    let userType = uData?["userType"] as? Int
                    let uniqueId = uData?["userUniqueId"] as? String
                    let applicationStatus = uData?["applicationStatus"] as? Int
                    let address = uData?["address"] as? String
                    let ethnicity = uData?["ethnicity"] as? Int
                    let gender = uData?["gender"] as? Int
                    let age = uData?["age"] as? Int
                    let email = uData?["email"] as? String
                    let password = ""
                    let newUser = User(id: id ?? 0,
                                       firstName: firstName ?? "",
                                       lastName: lastName ?? "",
                                       userType: userType ?? 0,
                                       userUniqueId: uniqueId ?? "",
                                       status: applicationStatus ?? 0,
                                       email: email ?? "",
                                       address: address ?? "",
                                       ethnicity: ethnicity ?? 0,
                                       age: age ?? 0,
                                       password: password,
                                       gender: gender ?? 0)
                    userList.append(newUser)
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            users(userList)
        }
        
        task.resume()
        
    }
}

