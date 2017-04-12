//
//  StudentController.swift
//  StudentPut
//
//  Created by handje on 4/12/17.
//  Copyright © 2017 Rob Hand. All rights reserved.
//

import Foundation

class StudentController {
    
    static let baseURL = URL(string: "https://students-e8889.firebaseio.com/students")
    static let getterEndPoint = baseURL?.appendingPathExtension("json")
    
    // Fetch Method
    
    static func fetchStudents(completion: @escaping ([Student]) -> Void) {
        
        guard let getterEndPoint = getterEndPoint else { return } //URL's are optional, must unwrap
        
        NetworkController.performRequest(for: getterEndPoint, httpMethod: .get) { (data, error) in
            guard let data = data else { completion([]); return }           //unwrap data, else run completion and return
            guard let studentsDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: [String: Any]] else {
                completion([])
                return
            }
            
            // [String: [String: Any]]
            // [Key: Value([Key: Value])]
            // [$0: [.0: .1]] --- $0, String key --> .0 is key and .1 is value(studentName)
            let students = studentsDictionary.flatMap { Student(dictionary: $0.1) }
            completion(students)
        }
    }
    
    // Post Method
        
    static func post(studentWithName name: String, completion: ((_ success: Bool) -> Void)? = nil) {
        
        let student = Student(name: name)
        guard let url = baseURL?.appendingPathComponent(name).appendingPathExtension("json") else { return }
        
        NetworkController.performRequest(for: url, httpMethod: .put, body: student.jsonData) { (data, error) in
            var success = false
            defer { completion?(success) }       //defer to this statement whenever you leave scope
            
            guard let data = data, let responseDataString = String(data: data, encoding: .utf8) else { return }
            
            if error != nil {
                print("Error: \(error)")
            } else if responseDataString.contains("error") {
                print("Error: \(responseDataString)")
            } else {
                print("Success: \nResponse: \(responseDataString)")
                success = true
            }
        }
    }
}

















