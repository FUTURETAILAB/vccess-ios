//
//  SignInTableViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/2/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController
{
    @IBOutlet weak var btnRememberMe: UIButton!
    @IBOutlet weak var txtViewLegal: UITextView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        btnRememberMe.layer.borderColor = UIColor.black.cgColor
        btnRememberMe.layer.borderWidth = 1.0
        btnRememberMe.layer.cornerRadius = 1.0
        
        self.txtViewLegal.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.txtViewLegal.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let string: String = txtViewLegal.attributedText.string
        if let privacyRange: Range = string.range(of: "Privacy Policy")
            , let tcRange: Range = string.range(of: "Terms of Use")
        {
            let aString: NSMutableAttributedString = NSMutableAttributedString(attributedString: txtViewLegal.attributedText)
            aString.addAttribute(NSAttributedString.Key.link, value: "vccess://privacy-policy", range: NSRange(privacyRange, in: aString.string))
            aString.addAttribute(NSAttributedString.Key.link, value: "vccess://terms", range: NSRange(tcRange, in: aString.string))
            txtViewLegal.attributedText = aString
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if let nav = segue.destination as? UINavigationController
            , let vc = nav.viewControllers.first as? LinkViewController
            , let url = sender as? String
        {
            vc.path = url
        }
    }

    @IBAction func signIn(sender: UIButton)
    {
        self.performSegue(withIdentifier: "sgNotifications", sender: nil)
    }
    
    @IBAction func rememberMe(sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func back(sender: UIBarButtonItem)
    {
        if let nav = self.navigationController
        {
            nav.popViewController(animated: true)
        }
    }
    
    @IBAction func register(sender: UIBarButtonItem)
    {
        if let nav = self.navigationController
        {
            nav.popToRootViewController(animated: true)
        }
    }

}

extension SignInViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtEmail
        {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword
        {
            txtPassword.resignFirstResponder()
        }
        
        return true
    }
}

extension SignInViewController: UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    {
        if URL.absoluteString.contains("privacy")
            , let path = Configuration.shared.fetch(configurationProperty: .PrivacyPolicyURL)
        {
            self.performSegue(withIdentifier: "sgLink", sender: path)
        }

        if URL.absoluteString.contains("terms")
            , let path = Configuration.shared.fetch(configurationProperty: .TermsOfUseURL)
        {
            self.performSegue(withIdentifier: "sgLink", sender: path)
        }

        return true
    }
}

