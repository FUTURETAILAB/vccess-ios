//
//  AddressViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/28/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController
{
    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtLast: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    @IBAction func done(sender: UIButton)
    {
        
    }
    
    @IBAction func save(sender: UIButton)
    {
        
    }
}

extension AddressViewController: UITextFieldDelegate
{
    
}
