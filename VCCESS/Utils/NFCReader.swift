//
//  NFCReader.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/17/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit
import CoreNFC

class NFCReader: NSObject
{
    static let shared = NFCReader()

//    var session: NFCTagReaderSession?
    var sessionNDEF: NFCNDEFReaderSession?

    
    func start()
    {
        sessionNDEF = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        sessionNDEF?.alertMessage = "To unlock and authenticate, place your phone on the VCCESS TAG."
        sessionNDEF?.begin()
    }
}

extension NFCReader: NFCNDEFReaderSessionDelegate
{
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error)
    {
        print("test")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage])
    {
        print("test")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag])
    {
        print("test")

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

extension NFCReader: NFCTagReaderSessionDelegate
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

