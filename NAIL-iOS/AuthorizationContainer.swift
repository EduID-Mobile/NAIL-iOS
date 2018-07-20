//
//  AuthorizationContainer.swift
//  NAIL-iOS
//
//  Created by Blended Learning Center on 20.07.18.
//  Copyright © 2018 Blended Learning Center. All rights reserved.
//

import Foundation

class AuthorizationContainer {
    
    private var api_key : String
    private var token_type : String
    private var access_token : String
    private var expires_in : Int
    private var package : [String: Any]
    
    init(authDict : [String: Any]) {
        if authDict.keys.contains("api_key") && authDict.keys.contains("token_type") && authDict.keys.contains("access_token") && authDict.keys.contains("expires_in") {
            self.package = authDict
            self.api_key = String(describing: authDict["api_key"]!)
            self.token_type = String(describing: authDict["token_type"]!)
            self.access_token = String(describing: authDict["access_token"]!)
            self.expires_in = authDict["expires_in"]! as! Int
        }
        else{
            fatalError("Keys not found in Authorization tag")
        }
    }
    
    func getAuthPackage() -> [String: Any] {
        return self.package
    }
    
    func getApiKey () -> String {
        return self.api_key
    }
    
    func getTokenType () -> String {
        return self.token_type
    }
    
    func getAccessToken () -> String {
        return self.access_token
    }
    
    func getExpiresTime () -> Int {
        return self.expires_in
    }
    
}
