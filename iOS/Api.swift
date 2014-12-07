//
//  Api.swift
//  iOS
//
//  Created by Alejandro Perezpaya on 06/12/14.
//  Copyright (c) 2014 Authy. All rights reserved.
//

import Foundation

class Api {
    
    let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    let domain: String
    
    var manager: Manager!
    let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
    init(domain: String) {
        // perform some initialization here
        self.domain = domain
        self.manager = self.configureManager()
        
        manager.session.configuration.HTTPAdditionalHeaders = [
            "X-Api": "true"
        ]
    }
    
    func configureManager() -> Manager {
        let cfg = NSURLSessionConfiguration.defaultSessionConfiguration()
        cfg.HTTPCookieStorage = cookies
        return Manager(configuration: cfg)
    }
    
    func shouldLogin(cb: (Bool) -> ()) {
        
        manager.request(NSURLRequest(URL: NSURL(string: "http://\(self.domain)/login")!)).response {
            (req, res, data, err) in
            
            if err != nil {
                cb(false)
            } else {
                if res?.statusCode == 200 {
                    cb(true)
                } else {
                    cb(false)
                }
            }

        }
        
    }
    
    func loginWithPin(pin: String, cb: (Bool, NSError?) -> ()) {
        
        manager.request(Method.POST, "http://\(self.domain)/login", parameters: ["code": pin], encoding: ParameterEncoding.URL).response {
            (req, res, data, err) in
            
            if err != nil {
                cb(false, err)
            } else {
                if res?.statusCode == 200 {
                    cb(true, nil)
                } else {
                    cb(false, nil)
                }
            }
            
        }
        
    }
    
    func getProviders(cb: (JSON, NSError?) -> ()) {
        
        manager.request(NSURLRequest(URL: NSURL(string: "http://\(self.domain)/providers")!)).responseSwiftyJSON { (_, res, json, err) -> Void in
            if res?.statusCode == 200 {
                cb(json, nil)
            } else {
                cb(nil, err)
            }
        }
    }
    
    func logout(cb: () -> ()) {
    
        manager.request(NSURLRequest(URL: NSURL(string: "http://\(self.domain)/logout")!)).response {
            (req, res, data, err) in
                cb()
        }
    
    }
    
}

