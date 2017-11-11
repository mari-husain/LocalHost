//
//  Item.swift
//  LocalHost
//
//  Created by Mari Husain on 10/19/17.
//  Copyright © 2017 Mari Husain. All rights reserved.
//

import UIKit
import os.log

class Item: NSObject, NSCoding {
    // MARK: Properties
    var title: String
    var photo: UIImage?
    var price: Float
    
    // MARK: Types
    struct PropertyKey {
        static let title = "title"
        static let photo = "photo"
        static let price = "price"
    }
    
    
    // MARK: Initializers
    init?(title: String, photo: UIImage?, price: Float) {
        
        if(price < 0 || title.isEmpty){
            return nil
        }
        
        // initialize stored properties.
        self.title = title
        self.photo = photo
        self.price = price
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(price, forKey: PropertyKey.price)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // the title and price are required. If we cannot decode these, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the name for an Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let price = aDecoder.decodeFloat(forKey: PropertyKey.price)
        
        if price == 0 {
            os_log("Unable to decode the price for an Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        self.init(title: title, photo: photo, price: price)
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("items")
}
