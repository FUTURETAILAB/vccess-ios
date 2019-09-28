//
//  AddPaymentViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/28/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class AddPaymentViewController: UIViewController
{
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    @IBAction func done(sender: UIButton)
    {
        if let nav = self.navigationController
            , let presenting = nav.presentingViewController
        {
            DispatchQueue.main.async
            {
                presenting.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func autoScan(sender: UIButton)
    {
        
    }
    
    @IBAction func addCard(sender: UIButton)
    {
        
    }
}
