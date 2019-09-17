//
//  ScannerViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/16/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit
import CoreNFC

//  https://developer.apple.com/videos/play/wwdc2019/715/

class ScannerViewController: UIViewController
{
    var session: NFCTagReaderSession?
//    var sessionNDEF: NFCNDEFReaderSession?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        session?.alertMessage = "To unlock and authenticate collectible, place your phone on the VCCESS TAG symbol."
        session?.begin()

        
//        sessionNDEF = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
//        sessionNDEF?.alertMessage = "To unlock and authenticate collectible, place your phone on the VCCESS TAG symbol."
//        sessionNDEF?.begin()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if let nav = self.navigationController
            , let tab = nav.tabBarController
        {
            tab.tabBar.isHidden = true
        }
    }
    

    @IBAction func close(sender: UIBarButtonItem)
    {
        if let nav = self.navigationController
            , let tab = nav.tabBarController as? MainTabBarViewController
        {
            tab.selectPreviousItem()
            tab.tabBar.isHidden = false
        }
    }

}

extension ScannerViewController: NFCNDEFReaderSessionDelegate
{
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error)
    {
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage])
    {
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag])
    {
        if let tag = tags.first
        {
            session.connect(to: tag, completionHandler:
            {
                error in
            })
            
            tag.queryNDEFStatus(completionHandler:
            {
                status, capacity, error in
                
                if status == .readWrite
                {
                    if let msg: NFCNDEFMessage = NFCNDEFMessage(data: Data())
                    {
                        tag.writeNDEF(msg, completionHandler:
                        {
                            error in
                            
                            session.invalidate()
                        })
                    }
                }
            })
        }
    }
    
}

extension ScannerViewController: NFCTagReaderSessionDelegate
{
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession)
    {
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error)
    {
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag])
    {
        
    }
}
