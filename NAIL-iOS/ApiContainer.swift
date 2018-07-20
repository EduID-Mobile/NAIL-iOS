//
//  ApiContainer.swift
//  NAIL-iOS
//
//  Created by Blended Learning Center on 20.07.18.
//  Copyright © 2018 Blended Learning Center. All rights reserved.
//

import Foundation

class  ApiContainer {
    
    private var id: Int?
    private var name : String
    private var version : String?
    private var transport : String?
    private var apiLink : String?
    private var engineID: String?
    private var docs : String?
    private var preffered : Bool?
    private var description : String?
    private var notes : String?
    private var settings : Any?
    private var id_platform : Int?
    private var token_type : String?
    private var auth : [Any]?
    
    
    init(name : String , authData : [String : Any]) {
        self.name = name
        if authData.keys.contains("apiLink"){
            self.apiLink = authData["apiLink"] as? String
        }
        
        if authData.keys.contains("transport"){
            self.transport = authData["transport"] as? String
        }
        
        if authData.keys.contains("apiVersion"){
            self.version = authData["apiVersion"] as? String
        }
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getApiLink() -> String? {
        return self.apiLink
    }
    
    func getTransport() -> String? {
        return self.transport
    }
    
    func getVersion() -> String? {
        return self.version
    }
    
}
