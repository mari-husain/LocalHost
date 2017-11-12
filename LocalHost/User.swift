//
//  User.swift
//  LocalHost
//
//  Created by Mari Husain on 11/11/17.
//  Copyright © 2017 Mari Husain. All rights reserved.
//

import UIKit

class User: NSObject {
    
    // MARK: Properties
    var name: String
    var location: String
    
    // MARK: Initializers
    init?(name: String, location: String) {
        
        // we cannot initialize a user without name and location info.
        if (name.isEmpty || location.isEmpty) {
            return nil
        }
        
        self.name = name
        self.location = location
    }
    
    // initialize a user object from JSON
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let location = json["location"] as? String
        else {
            return nil
        }
        
        self.name = name
        self.location = location
    }
}
