//
//  NativeAppIntegrationLayer.swift
//  NAIL-iOS
//
//  Created by Blended Learning Center on 20.07.18.
//  Copyright © 2018 Blended Learning Center. All rights reserved.
//

import Foundation

public class NativeAppIntegrationLayer {
    
    private var serviceNames = [String]()
    private var endpointUrl  = [String]()
    private var displayNames = [String]()
    private var serviceUrl = [String]()
    private var serviceToken = [String]()
    
    // nested variable
    // single service could have several apis, single api represented as ApiContainer here
    private var apis = [[ApiContainer]]()
    private var authorization = [AuthorizationContainer]()
    
    
    private var responseData : Any?
    
    public init(inputData: Data){
        
        //inputData : Data
        do{
            let json = try JSONSerialization.jsonObject(with: inputData, options: [])
            responseData = json
            for service in json as! [Any] {
                let jsonEntry = service as! [String : Any]
                parseEntry(jsonDict: jsonEntry)
            }
            
        } catch {
            print("Error on parsing json data in NAIL API")
            return
        }
    }
    
    public init ( serializedStr : String ){
        parse(serialization: serializedStr)
    }
    
    public func parse(serialization : String ) {
        guard let data = serialization.data(using: .utf8, allowLossyConversion: false) else {
            return
        }
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let responseData = json as? [String: Any] else {
                return
            }
            for keyService in responseData.keys {
                let jsonEntry = responseData[keyService] as! [Any]
                parseEntry(jsonDict: jsonEntry.first as! [String : Any])
                return
            }
        } catch {
            print("Error on parsing the serialized Data")
            return
        }
    }
    
    
    func parseEntry(jsonDict : [String: Any]){
        
        guard let name = jsonDict["engineName"] as? String else{ return; }
        guard let endpoint = jsonDict["engineLink"] as? String else{ return; }
        guard let homePageLink = jsonDict["homePageLink"] as? String else{ return; }
        guard let apisJson = jsonDict["apis"] as? [String: Any] else{ return; }
        guard let authDictTmp = jsonDict ["authorization"] as? [String : Any] else{ return; }
        serviceNames.append(name)
        endpointUrl.append(endpoint)
        serviceUrl.append(homePageLink)
        var api = [ApiContainer]()
        for apiName in apisJson.keys{
            let apiTmp = ApiContainer(name: apiName, authData: apisJson[apiName] as! [String : Any] )
            api.append(apiTmp)
        }
        apis.append(api)
        authorization.append( AuthorizationContainer(authDict: authDictTmp) )
        
    }
    
    public func serialize() -> String {
        if responseData == nil {
            print("no response data found for serialize!")
            return ""
        }
        //wrap the response data into a services dictionary
        let wrapper : [String: Any] = ["services" : responseData!]
        do {
            let data = try JSONSerialization.data(withJSONObject: wrapper, options: .prettyPrinted)
            let convertedString = String(data: data, encoding: .utf8)
            return convertedString!
        }catch {
            print("Serialize : error on serializing json object")
            return ""
        }
        
    }
    
    func getServiceNames() -> [String] {
        return serviceNames
    }
    
    func getAccessToken (serviceName : String, protocolName : String) -> [String:Any]? {
        
        guard let index = serviceNames.index(of: serviceName) else {
            return nil
        }
        let authCon = authorization[index]
        var protocolFound : Bool = false
        for api in apis[index] {
            if  protocolName == api.getName() {
                protocolFound = true
                break
            }
        }
        if !protocolFound {
            return nil
        }
        
        //return authCon.getAccessToken()
        //for now return the api_key....
        return authCon.getAuthPackage()
        /*
         do {
         let jsonPackage = try JSONSerialization.data(withJSONObject: package, options: [])
         return jsonPackage
         }catch {
         print("getAccessToken: Error on serializing json")
         return nil
         }
         */
        
    }
    
    func getDisplayName (serviceName: String) -> String {
        
        if serviceNames.contains(serviceName) {
            return serviceName
        } else {
            return ""
        }
    }
    
    func getEndpointUrl ( serviceName : String, protocolName: String) -> String {
        
        guard let index = serviceNames.index(of: serviceName) else {
            return ""
        }
        let apiContainers = apis[index]
        let homeLink = serviceUrl[index]
        
        var res = homeLink
        for api in apiContainers {
            if api.getName() == protocolName{
                guard let apiLink = api.getApiLink() else {
                    continue
                }
                res += apiLink
                break
            }
        }
        return res
    }
    
    func getServiceUrl (serviceName: String) -> String {
        guard let index = serviceNames.index(of: serviceName) else {
            return ""
        }
        let result = serviceUrl[index]
        
        return result
    }
    
    func removeService(serviceName : String){
        guard let index = serviceNames.index(of: serviceName) else {
            print("Error on removing service : Cannot find the service name")
            return
        }
        serviceNames.remove(at: index)
        endpointUrl.remove(at: index)
        //        displayNames.remove(at: index)
        serviceUrl.remove(at: index)
        //serviceToken.remove(at: index)
        apis.remove(at: index)
        authorization.remove(at: index)
    }
    
    func clearAllService(){
        
        serviceNames.removeAll()
        endpointUrl.removeAll()
        serviceUrl.removeAll()
        apis.removeAll()
        authorization.removeAll()
        responseData = nil
    }
    
    
}
