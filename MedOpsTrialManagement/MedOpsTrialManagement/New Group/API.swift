//
//  API.swift
//  MedOpsTrialManagement
//
//  Created by Jaimin Patel on 2018-10-04.
//  Copyright © 2018 Jaimin Patel. All rights reserved.
//

import Foundation
class API {
    
    func getDiseases(completion: @escaping (_ diseases: [Diseases]) -> ()){
        let urlString : String = "https://medopscloud.azurewebsites.net/api/data/disease"
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
        urlComponent.scheme = "https"
        urlComponent.host = "medopscloud.azurewebsites.net"
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
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8){
                print("Response", utf8Representation)
            }else{
                print("no data recieved")
            }
        }
        task.resume()
    }
}
