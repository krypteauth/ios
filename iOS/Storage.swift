//
//  Storage.swift
//  iOS
//
//  Created by Alejandro Perezpaya on 06/12/14.
//  Copyright (c) 2014 Authy. All rights reserved.
//

import Foundation

class Storage {
    
    var storage = NSUserDefaults()
    
    func store(key: String, value: AnyObject?) {
        self.storage.setObject(value, forKey: key)
    }
    
    func getString(key: String) -> String {
        var string = self.storage.stringForKey(key)
        if string == nil {
            string = ""
        }
        
        return string!
    }
    
    func getObject(key: String) -> AnyObject? {
        return self.storage.objectForKey(key)!
    }

}