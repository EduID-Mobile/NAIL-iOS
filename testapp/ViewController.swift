//
//  ViewController.swift
//  testapp
//
//  Created by Blended Learning Center on 23.07.18.
//  Copyright © 2018 Blended Learning Center. All rights reserved.
//

import UIKit
import NAIL_iOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NAILapi.authorizeProtocols(protocolList: ["org.moodle.moodle_mobile_app"]) {
            print("IN TESTAPP ::" ,  $0)
        }
        print("res = ")
        //textView.text = res
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

