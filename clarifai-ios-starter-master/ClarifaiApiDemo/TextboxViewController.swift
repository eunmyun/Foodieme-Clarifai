//
//  TextboxViewController.swift
//  ClarifaiApiDemo
//
//  Created by MyungJin Eun on 5/19/16.
//  Copyright © 2016 Clarifai, Inc. All rights reserved.
//

import UIKit

class TextboxViewController: UIViewController {
    
    @IBOutlet weak var inputBox: UITextField!
    
    @IBAction func clickTextbox(sender: AnyObject) {
        if inputBox.textColor == UIColor.lightGrayColor() {
            inputBox.text = nil
            inputBox.textColor = UIColor.blackColor()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        inputBox.text = "Type in items separated by a space"
        inputBox.textColor = UIColor.lightGrayColor()
    }
    
    func inputBoxDidBeginEditing(inputBox: UITextField) {
        
    }
    
    @IBAction func submit(sender: AnyObject) {
        var foodlist = self.inputBox.text
        var foodarray = foodlist!.componentsSeparatedByString(" ")
        
        print(foodarray)
        //submit clicked
    }
    
}
