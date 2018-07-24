//
//  EduIDPlugin.swift
//  NAIL-iOS
//
//  Created by Blended Learning Center on 20.07.18.
//  Copyright © 2018 Blended Learning Center. All rights reserved.
//

import Foundation
import MobileCoreServices

enum NailApiError : Error {
    case parsingError(String)
}

public class NAILapi {
    
    private static var nail: NativeAppIntegrationLayer?
    private var result : BoxBinding<String?> = BoxBinding(nil)
    
    public static func authorizeProtocols(protocolList:[String], singleton : Bool = true, completion: @escaping (String)->()) {
        //Combine both parameter into one string array, this will be passed into the Extension Layer
        var itemForExtension = protocolList
        itemForExtension.append(singleton.description)
        
        let activityVC = UIActivityViewController(activityItems: itemForExtension, applicationActivities: nil)
        if activityVC.responds(to: #selector(getter: UIApplication.shared.keyWindow?.rootViewController?.popoverPresentationController)) {
            activityVC.popoverPresentationController?.sourceView = UIApplication.shared.keyWindow?.rootViewController?.view
        }
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
        
        //var result : String = ""
        activityVC.completionWithItemsHandler = {
            activityType, completed, returnedItems, error in
            print("NAIL log :: back from extension")
            
            if(returnedItems == nil || returnedItems!.count <= 0){
                print("NAIL log :: No item found from the extension")
                completion("")
            } else {
                let item : NSExtensionItem = returnedItems?.first as! NSExtensionItem
                var response = self.extractDataFromExtension(item: item, completion: { (escapeResponse) in
                    completion(escapeResponse)
                })
            }
        }
        
    }
    
    //Extract the data from the extension
    private static func extractDataFromExtension(item : NSExtensionItem, completion: @escaping (String) -> () )  {
        
        var response: String?
        DispatchQueue.global(qos: .background).async {
            let itemProvider = item.attachments?.first as! NSItemProvider
            
            if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeJSON as String){
                itemProvider.loadItem(forTypeIdentifier: kUTTypeJSON as String, options: nil, completionHandler: { (data, error) -> Void in
                    if error != nil {
                        print("error on extracting data from extension , \(error.localizedDescription)")
                        response = ""
                    }
                    let jsonData = data as! Data
                    NAILapi.nail = NativeAppIntegrationLayer(inputData: jsonData)
                    
                    //returned items is in json format
                    response = self.getNail()!.serialize()
                    print("DATA SOURCE : \(String(describing: response))")
                    completion(response!)
                })
            }
        }
    }
    
    public static func serviceNames() -> [String]? {
        guard let nailtmp = self.getNail() else {
            return nil
        }
        return nailtmp.getServiceNames()
    }
    
    public static func getEndpointUrl(serviceName : String , protocolName : String, endpointPath: String? = "") -> String? {
        //TODO endpointPath handler
        guard let nailtmp = self.getNail() else {
            return nil
        }
        return nailtmp.getEndpointUrl(serviceName: serviceName, protocolName: protocolName)
        
    }
    
    public static func getDisplayName(serviceName: String) -> String? {
        guard let nailtmp = self.getNail() else {
            return nil
        }
        
        return nailtmp.getDisplayName(serviceName: serviceName)
    }
    
    public static func getServiceToken(serviceName : String, protocolName : String) -> String? {
        guard let nailtmp = self.getNail() else {
            return nil
        }
        
        let authPackage = nailtmp.getAccessToken(serviceName: serviceName, protocolName: protocolName)
        return authPackage?["api_key"] as? String
        //nailtmp.getA
    }
    
    public static func getServiceUrl(serviceName : String ) -> String? {
        guard let nailtmp = self.getNail() else {
            return nil
        }
        return nailtmp.getServiceUrl(serviceName:serviceName)
    }
    
    public static func removeService(serviceName: String) {
        guard let nailtmp = self.getNail() else {
            return
        }
        return nailtmp.removeService(serviceName: serviceName)
    }
    
    public static func clearAllService(){
        guard let nailtmp = self.getNail() else {
            return
        }
        nailtmp.clearAllService()
    }
    
    //return empty string if there any error
    public static func serialize() -> String{
        guard let nailtmp = self.getNail() else {
            return ""
        }
        let result = nailtmp.serialize()
        return result
    }
    
    public static func parse(nailSerialization : String) throws {
        let nailtmp = NativeAppIntegrationLayer(serializedStr: nailSerialization)
        
        if nailtmp.getServiceNames().count <= 0 {
            throw NailApiError.parsingError("Error while trying to parse the serialized Data")
        } else {
            NAILapi.nail = nailtmp
        }
    }
    
    public static func getNail()-> NativeAppIntegrationLayer? {
        if NAILapi.nail == nil{
            return nil
        }
        return NAILapi.nail!
        
    }
    
}
