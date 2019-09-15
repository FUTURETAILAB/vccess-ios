//
//  SignInTableViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/2/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController
{
    @IBOutlet weak var btnRememberMe: UIButton!
    @IBOutlet weak var txtViewLegal: UITextView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtUsername: UITextField!

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

    
    @IBAction func back(sender: UIBarButtonItem)
    {
        if let nav = self.navigationController
        {
            nav.popViewController(animated: true)
            
        }
    }

    @IBAction func createAccount(sender: UIButton)
    {
        self.performSegue(withIdentifier: "sgNotifications", sender: nil)
    }

    @IBAction func rememberMe(sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func login(sender: UIButton)
    {
        if let nav = self.navigationController
            , let vc = nav.viewControllers.first as? PhoneNumberViewController
        {
            nav.popToRootViewController(animated: false)
            vc.performSegue(withIdentifier: "sgLogin", sender: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            txtEmail.becomeFirstResponder()
        }
        else if indexPath.row == 1
        {
            txtPassword.becomeFirstResponder()
        }
        else if indexPath.row == 2
        {
            txtFirstName.becomeFirstResponder()
        }
        else if indexPath.row == 3
        {
            txtLastName.becomeFirstResponder()
        }
        else if indexPath.row == 4
        {
            txtDOB.becomeFirstResponder()
        }
        else if indexPath.row == 5
        {
            txtUsername.becomeFirstResponder()
        }
    }
    
}

extension SignUpTableViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtEmail
        {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword
        {
            txtFirstName.becomeFirstResponder()
        }
        else if textField == txtFirstName
        {
            txtLastName.becomeFirstResponder()
        }
        else if textField == txtLastName
        {
            txtDOB.becomeFirstResponder()
        }
        else if textField == txtDOB
        {
            txtUsername.becomeFirstResponder()
        }
        else if textField == txtUsername
        {
            txtUsername.resignFirstResponder()
        }
        
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == txtEmail
        {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        else if textField == txtPassword
        {
            self.tableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: .top, animated: true)
        }
        else if textField == txtFirstName
        {
            self.tableView.scrollToRow(at: IndexPath(row: 2, section: 0), at: .top, animated: true)
        }
        else if textField == txtLastName
        {
            self.tableView.scrollToRow(at: IndexPath(row: 3, section: 0), at: .top, animated: true)
        }
        else if textField == txtDOB
        {
            self.tableView.scrollToRow(at: IndexPath(row: 4, section: 0), at: .top, animated: true)
        }
        else if textField == txtUsername
        {
            self.tableView.scrollToRow(at: IndexPath(row: 5, section: 0), at: .top, animated: true)
        }
    }

}

extension SignUpTableViewController: UITextViewDelegate
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
