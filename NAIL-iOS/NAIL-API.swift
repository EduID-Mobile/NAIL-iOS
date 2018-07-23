//
//  EduIDPlugin.swift
//  NAIL-iOS
//
//  Created by Blended Learning Center on 20.07.18.
//  Copyright © 2018 Blended Learning Center. All rights reserved.
//

import Foundation
import MobileCoreServices

public class NAILapi {
    
    private static var nail: NativeAppIntegrationLayer?
    static let group = DispatchGroup() //controlling the async flow for the authorizeProtocols
    
    public static func authorizeProtocols(protocolList:[String], singleton : Bool = true) -> String {
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
        
        var result : String = ""
        
        activityVC.completionWithItemsHandler = {
            activityType, completed, returnedItems, error in
            print("NAIL log :: back from extension")
            
            if(returnedItems == nil || returnedItems!.count <= 0){
                print("NAIL log :: No item found from the extension")
                
            } else {
                let item : NSExtensionItem = returnedItems?.first as! NSExtensionItem
                group.enter()
        
                guard let response = self.extractDataFromExtension(item: item) else {
                    print("NAIL log : empty response from extension")
                    return
                }
                group.wait()
                if response.count >= 0 {
                    result = response
                }
            }
        }
        
        return result
    }
    
    //Extract the data from the extension
    private static func extractDataFromExtension(item : NSExtensionItem) -> String? {
        var response: String?
        DispatchQueue.global(qos: .background).async {
            
            let itemProvider = item.attachments?.first as! NSItemProvider
            
            if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeJSON as String){
                itemProvider.loadItem(forTypeIdentifier: kUTTypeJSON as String, options: nil, completionHandler: { (data, error) -> Void in
                    if error != nil {
                        print("error on extracting data from extension , \(error.localizedDescription)")
                        response = nil
                    }
                    let jsonData = data as! Data
                    NAILapi.nail = NativeAppIntegrationLayer(inputData: jsonData)
                    
                    //returned items is in json format
                    response = self.getNail()!.serialize()
                    print("DATA SOURCE : \(String(describing: response))")
                    
                    
                    //let x = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response)
                    //self.commandDelegate.send(x, callbackId: self.command?.callbackId)
                })
            }
        }
        group.leave()
        return response
    }
    
    public static func getNail()-> NativeAppIntegrationLayer? {
        if NAILapi.nail == nil{
            return nil
        }
        return NAILapi.nail!
        
    }
    
}




/*

func authorizeProtocols(command: CDVInvokedUrlCommand){
    
    //set the protocols and and singleton for the extension
    let singleton = true
    self.command = command
    print("Args : " , command.arguments)
    print("IN PLUGIN SWIFT , singleton : \(singleton)")
    
    let arg = command.arguments.first as! [String : Any]
    var item = arg["protocols"] as! [String]
    item.append(singleton.description)
    
    let activityVC = UIActivityViewController(activityItems: item, applicationActivities: nil)
    if activityVC.responds(to: #selector(getter: self.viewController.popoverPresentationController)) {
        activityVC.popoverPresentationController?.sourceView = self.viewController.view
    }
    
    DispatchQueue.main.async {
        self.viewController.present(activityVC, animated: true, completion: nil)
    }
    
    activityVC.completionWithItemsHandler = {
        activityType, completed, returnedItems, error in
        print("BACK FROM EXTENSION")
        if(returnedItems == nil || returnedItems!.count <= 0){
            print("No Item found from extension")
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }else {
            let item : NSExtensionItem = returnedItems?.first as! NSExtensionItem
            self.extractDataFromExtension(item: item)
        }
    }
}

@objc(authorizeProtocols2:)
func authorizeProtocols2(command: CDVInvokedUrlCommand){
    
    // var x = self.getNail()
    //print("NAIL TEXT non Singleton : " , x.getText())
    //set the protocols and and singleton for the extension
    let singleton = false
    self.command = command
    print("Args : " , command.arguments)
    print("IN PLUGIN SWIFT , singleton : \(singleton)")
    
    let arg = command.arguments.first as! [String : Any]
    var item = arg["protocols"] as! [String]
    item.append(singleton.description)
    
    let activityVC = UIActivityViewController(activityItems: item, applicationActivities: nil)
    if activityVC.responds(to: #selector(getter: self.viewController.popoverPresentationController)) {
        activityVC.popoverPresentationController?.sourceView = self.viewController.view
    }
    DispatchQueue.main.async {
        self.viewController.present(activityVC, animated: true, completion: nil)
    }
    
    activityVC.completionWithItemsHandler = {
        activityType, completed, returnedItems, error in
        print("BACK FROM EXTENSION")
        if(returnedItems == nil || returnedItems!.count <= 0){
            print("No Item found from extension")
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }else {
            let item : NSExtensionItem = returnedItems?.first as! NSExtensionItem
            self.extractDataFromExtension(item: item)
        }
    }
}*/
