//
//  ViewController.swift
//  iOS
//
//  Created by Alejandro Perezpaya on 06/12/14.
//  Copyright (c) 2014 Authy. All rights reserved.
//

import UIKit
import QuartzCore
    
class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var domainField: UITextField?
    
    var api: Api?
    var storage = Storage()
    
    var domain: String?
    
    @IBOutlet var number1: UITextField?
    @IBOutlet var number2: UITextField?
    @IBOutlet var number3: UITextField?
    @IBOutlet var number4: UITextField?
    @IBOutlet var number5: UITextField?
    @IBOutlet var number6: UITextField?
    
    var textfields: [UITextField?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initView () {
        
        domain = self.getDomain()
        domainField?.delegate = self
        
        if domain != nil {
            self.api = Api(domain: domain!)
        }
        
        self.api?.shouldLogin({ (logged) -> () in
            if logged == true {
                self.loadInfoViewController()
            } else {
                self.textfields = [self.number1, self.number2, self.number3, self.number4, self.number5, self.number6]
                
                var boxColor = UIColor(red: 226, green: 241, blue: 249, alpha: 0.3)
                
                self.domainField?.keyboardAppearance = UIKeyboardAppearance.Dark
                
                for f in self.textfields {
                    var field: UITextField = f!
                    field.keyboardType = UIKeyboardType.NumberPad
                    field.keyboardAppearance = UIKeyboardAppearance.Dark
                    field.layer.masksToBounds = true
                    field.layer.cornerRadius = 5.0
                    field.layer.borderColor = boxColor.CGColor
                    field.layer.borderWidth = 1.0
                    field.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSForegroundColorAttributeName: boxColor])
                }
                
                
                self.viewerino()
            }
        })
        
    }
    
    func viewerino () {
        
        domainField?.text = domain
        
        if domain == nil || domain == "" {
            domainField?.text = "Tap here to add your domain"
        }
        
    }
    
    func getDomain() -> String {
        return self.storage.getString("domain")
    }
    
    func setDomain() {
        
        domain = domainField?.text
        
        if domainField?.text == "" {
            domain == nil
        }
        
        viewerino()
    }
    
    func performAuth () {
        self.storage.store("domain", value: domain)
        self.api = Api(domain: domain!)
        var code = self.textfields.reduce("", combine: { (acc: String, field: UITextField?) -> String in
            return "\(acc)\(field!.text)"
        })
        
        self.api?.loginWithPin(code, cb: { (logged, err) -> () in
            if logged == true {
                self.loadInfoViewController()
            } else {
                println("nope")
            }
        })
    }
    
    func selectNextTextFieldWithTextField (textField: UITextField) {
        
        if textField.tag == 6 {
            return
        }
        
        var nextTextField: UITextField? = self.textfields[textField.tag]
        var color = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        textField.layer.borderColor = color.CGColor
        textField.textColor = color
        nextTextField?.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        println(textField.tag)
        
        if textField.tag == 0 {
            setDomain()
            domainField?.alpha = 0.3
        }
        if textField.tag == 6 {
            performAuth()
        } else {
            selectNextTextFieldWithTextField(textField)
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 0 {
            domainField?.text = ""
            domainField?.alpha = 1.0
        } else {
            var blueColor = UIColor(red: 46, green: 170, blue: 255, alpha: 1.0)
            textField.layer.borderColor = blueColor.CGColor
            textField.layer.borderWidth = 1.0
            textField.textColor = blueColor
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        selectNextTextFieldWithTextField(textField)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            return true
        } else {
            if range.location >= 1 {
                textField.endEditing(true)
                selectNextTextFieldWithTextField(textField)
                return true
            } else {
                return true
            }
            
        }
        
    }
    
    func loadInfoViewController () {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("info") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}