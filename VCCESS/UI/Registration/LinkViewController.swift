//
//  LinkViewController.swift
//  PointClub
//
//  Created by Todd Mathison on 8/4/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit
import WebKit

class LinkViewController: UIViewController
{
    @IBOutlet weak var webView: WKWebView!

    var path: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        if let path = path
            , let url = URL(string: path)
        {
            let urlRequest: URLRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
    
    @IBAction func close(sender: UIBarButtonItem)
    {
        if let nav = self.navigationController
            , let presenting = nav.presentingViewController
        {
            presenting.dismiss(animated: true, completion: nil)
        }
    }
}

extension LinkViewController: WKUIDelegate, WKNavigationDelegate
{
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load")
        
        ActivityManager.shared.incrementActivityCount()
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        
        ActivityManager.shared.decrementActivityCount()
    }
}
