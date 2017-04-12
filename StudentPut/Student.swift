//
//  Student.swift
//  StudentPut
//
//  Created by handje on 4/12/17.
//  Copyright © 2017 Rob Hand. All rights reserved.
//

import Foundation

struct Student {
    
    let name: String
}


// MARK: - JSON Init

extension Student {
    
    static let kName = "students"
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[Student.kName] as? String else { return nil }
        self.init(name: name)
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [Student.kName: name]
    }
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: .prettyPrinted)
    }
}
