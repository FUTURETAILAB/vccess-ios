//
//  BUser.swift
//  Buhbler
//
//  Created by Todd Mathison on 12/13/18.
//  Copyright © 2018 Buhbler LLC. All rights reserved.
//

import UIKit

@objc public protocol UserDelegate
{
    @objc optional func userLoginComplete()
    @objc optional func userLogoutComplete()
    @objc optional func userProfileUpdated()
}

enum SocialType
{
    case none
    case facebook
    case twitter
    case linkedIn
}

enum GenderType: String
{
    case none
    case male
    case female
}

enum AuthenticationStatus : Int
{
    case none
    case authenticated
    case expired
    case loginInProgress
}


protocol UserProtocol
{
    func removeArchive()
    func archive()
    func unarchive()
}

class User: NSObject, NSCoding, NSCopying, UserProtocol
{
    public static let shared = User()
    public var userDelegates : NSHashTable<UserDelegate> = NSHashTable.weakObjects()
    public static let UserNotificationsUpdated: String = "UserNotificationsUpdated"
    
    weak var network: NetworkProtocol? = Network.shared

    var notifications: Bool = true
    
    var userName: String?
    var password : String?
    var email: String?
    var phone: String?
    var firstName: String?
    var lastName: String?
    var lastLogin: Date = Date.init(timeIntervalSince1970: 0)
    var userID: Int?

    var authKey: String?
    var emailVerificationLink: String?
    
    var facebookID: String?
    var twitterID: String?
    var birthDate: Date?
    
    var genderType: GenderType = .none
    
    
    private var authStatus : AuthenticationStatus = .none
    
    var authenticationStatus : AuthenticationStatus
    {
        get
        {
            return self.authStatus
        }
    }
    
    override init()
    {
        super.init()
    }
    
    deinit
    {
    }
    
    func copy(with zone: NSZone? = nil) -> Any
    {
        let user: User = User()
        
        user.userID = self.userID
        user.userName = self.userName
        user.firstName = self.firstName
        user.lastName = self.lastName
        user.email = self.email

        return user
    }
    
    public required init(coder aDecoder: NSCoder)
    {
        if let value = aDecoder.decodeObject(forKey: "userID") as? Int { User.shared.userID = value }
        if let value = aDecoder.decodeObject(forKey: "userName") as? String { User.shared.userName = value }
        if let value = aDecoder.decodeObject(forKey: "firstName") as? String { User.shared.firstName = value }
        if let value = aDecoder.decodeObject(forKey: "lastName") as? String { User.shared.lastName = value }
        if let value = aDecoder.decodeObject(forKey: "authKey") as? String { User.shared.authKey = value }
        if let value = aDecoder.decodeObject(forKey: "email") as? String { User.shared.email = value }
        if let value = aDecoder.decodeObject(forKey: "password") as? String { User.shared.password = value }
        if let value = aDecoder.decodeObject(forKey: "lastLogin") as? Date { User.shared.lastLogin = value }
        if let value = aDecoder.decodeObject(forKey: "facebookID") as? String { User.shared.facebookID = value }
        if let value = aDecoder.decodeObject(forKey: "twitterID") as? String { User.shared.twitterID = value }
        if let value = aDecoder.decodeObject(forKey: "birthDate") as? Date { User.shared.birthDate = value }

        
        let authValue = aDecoder.decodeInteger(forKey: "authStatus")
        User.shared.authStatus = AuthenticationStatus(rawValue: authValue) ?? .none
        
        if let g = aDecoder.decodeObject(forKey: "genderType") as? String
        {
            User.shared.genderType = GenderType(rawValue: g) ?? .none
        }

        User.shared.notifications = aDecoder.decodeBool(forKey: "notifications")
        

    }
    
    public func encode(with aCoder: NSCoder)
    {
        
        aCoder.encode(userID, forKey: "userID")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(authKey, forKey: "authKey")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(lastLogin, forKey: "lastLogin")
        aCoder.encode(authStatus.rawValue, forKey: "authStatus")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(notifications, forKey: "notifications")
        aCoder.encode(facebookID, forKey: "facebookID")
        aCoder.encode(twitterID, forKey: "twitterID")
        aCoder.encode(birthDate, forKey: "birthDate")
        
        aCoder.encode(genderType.rawValue, forKey: "genderType")

        var arr: [Int] = []
        
        aCoder.encode(arr, forKey: "loadContacts")

    }
    
    func removeArchive()
    {
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.synchronize()
    }
    
    func archive()
    {
        do
        {
            let user = try NSKeyedArchiver.archivedData(withRootObject: User.shared, requiringSecureCoding: false)
            UserDefaults.standard.set(user, forKey: "user")
            UserDefaults.standard.synchronize()
        }
        catch
        {
        }
        
    }
    
    
    func unarchive()
    {
        guard let userData = UserDefaults.standard.data(forKey: "user")
            else
        {
            return()
        }
        
        if let u = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User
        {
            print("User decoding goes to User.shared.  It should go to the \"u\" user, and then here we set the shared properties")
        }
        
//        if self.authStatus == .authenticated
//        {
//            for obj in self.userDelegates.allObjects
//            {
//                if let r = obj.userLoginComplete
//                {
//                    r()
//                }
//            }
//        }
    }
    
    
    
    func hasCredentials() -> Bool
    {
        var existingCredentials : Bool = false
        var account = ""
        var password = ""
        var loginType = ""
        
        if let a = KeychainWrapper.stringForKey(kSecAttrAccount as String) {
            account = a
        }
        
        if let p = KeychainWrapper.stringForKey(kSecValueData as String) {
            password = p
        }
        
        if let lt = KeychainWrapper.stringForKey(kSecAttrDescription as String) {
            loginType = lt
        }
        
        
        if account.lowercased() == "account"
            && password.lowercased() == "password"
        {
            account = ""
            password = ""
            loginType = ""
            clearCredentials()
            self.authStatus = .none
        }
        
        if !account.isEmpty
            && !password.isEmpty
            && loginType.lowercased() == "password"
        {
            existingCredentials = true
        }
        
        return existingCredentials
        
    }
    
    func logout()
    {
        clearCredentials()
        
        userName = nil
        password = nil
        email = nil
        phone = nil
        firstName = nil
        lastName = nil
        lastLogin = Date.init(timeIntervalSince1970: 0)
        userID = nil
        authKey = nil
        emailVerificationLink = nil
        genderType = .none

        facebookID = nil
        twitterID = nil
        birthDate = nil
        
        authStatus  = .none

        self.removeArchive()
        
        for obj in self.userDelegates.allObjects
        {
            if let r = obj.userLogoutComplete
            {
                r()
            }
        }
        
    }
    
    func loginTasks()
    {
//        Push.shared.register()
        
    }
    
    func relogin(completionHandler: @escaping (_ error: NSError?) -> ()) -> Bool
    {
        var existingCredentials : Bool = false
        var account = ""
        var password = ""
        var loginType = ""
        
        if let a = KeychainWrapper.stringForKey(kSecAttrAccount as String) {
            account = a
        }
        
        if let p = KeychainWrapper.stringForKey(kSecValueData as String) {
            password = p
        }
        
        if let lt = KeychainWrapper.stringForKey(kSecAttrDescription as String) {
            loginType = lt
        }
        
        if account.lowercased() == "account"
            && password.lowercased() == "password"
        {
            account = ""
            password = ""
            loginType = ""
            clearCredentials()
            self.authStatus = .none
        }
        
        if !account.isEmpty
            && !password.isEmpty
            && loginType.lowercased() == "password"
        {
            existingCredentials = true
            
            if authStatus != .authenticated
            {
                self.authStatus = .loginInProgress
            }
            
            login(email: account, password: password, completion:
            {
                error in
                
                if let error = error
                {
                    if error.code == 403
                    {
                        self.clearCredentials()
                        self.authStatus = .none
                    }
                }
                
                completionHandler(error)
            })
        }
        else
        {
            let theError = NSError(domain: Configuration.shared.rootURL(), code: 0, userInfo: [NSLocalizedDescriptionKey: "No account info"])
            completionHandler(theError)
        }
        
        return existingCredentials
    }
    
    
    func clearCredentials()
    {
        _ = KeychainWrapper.setObject("" as NSCoding, forKey: kSecAttrAccount as String)
        _ = KeychainWrapper.setObject("" as NSCoding, forKey: kSecValueData as String)
        _ = KeychainWrapper.setObject("" as NSCoding, forKey: kSecAttrDescription as String)
        _ = KeychainWrapper.setObject(Date(timeIntervalSince1970: 0) as NSCoding, forKey: kSecAttrModificationDate as String)
    }
    
    
    func saveCredentials()
    {
        if let userName = self.userName
            , let password = self.password
        {
            _ = KeychainWrapper.setString(userName, forKey: kSecAttrAccount as String)
            _ = KeychainWrapper.setString(password, forKey: kSecValueData as String)
            _ = KeychainWrapper.setString("Password", forKey: kSecAttrDescription as String)
        }
        
        _ = KeychainWrapper.setObject(Date() as NSCoding, forKey: kSecAttrModificationDate as String)
    }
    
    func saveBiometricLogin()
    {
        if let userName = self.userName
            , let password = self.password
        {
            _ = KeychainWrapper.setString(String(format: "%@\n%@", userName, password), forKey: kSecAttrPersistantReference as String)
        }
    }
    
    func clearBiometricLogin()
    {
        _ = KeychainWrapper.setObject("" as NSCoding, forKey: kSecAttrPersistantReference as String)
    }
    
    func retrieveBiometricLogin() -> [String:String]
    {
        var dict: [String:String] = [:]
        
        if let credentials = KeychainWrapper.stringForKey(kSecAttrPersistantReference as String)
        {
            let components = credentials.components(separatedBy: "\n")
            if components.count == 2
                , let userName = components.first
                , let password = components.last
            {
                dict["userName"] = userName
                dict["password"] = password
            }
        }

        return dict
    }
    

    
//    "panel_id": 2,
//    "password": "qwerty",
//    "email": "arihant1@ongraph.com",
//    "gender": "Male",
//    "dob": "11-19-1993",
//    "zipcode": "302021",
//    "city": "Jaipur",
//    "state": "Rajasthan",
//    "country": "India",
//    "first_name": "Jon",
//    "last_name": "Snow",
//    "ho_id": "",
//    "aid": "",
//    "referral_code": ""
    
    func register(email: String
        , password: String
        , panelID: Int?
        , gender: String?
        , birthDate: Date?
        , postalCode: String?
        , city: String?
        , state: String?
        , country: String?
        , firstName: String
        , lastName: String
        , hoID: Int?
        , aid: Int?
        , referralCode: String?
        , completion: @escaping (_ error: NSError?) -> ())
    {
        
        guard let url = Configuration.shared.fetch(configurationProperty: .RegisterAPI) as? String
            , let authToken = Configuration.shared.fetch(configurationProperty: .AuthKey) as? String
            , let recaptchaKey = Configuration.shared.fetch(configurationProperty: .RecaptchaKey) as? String
        else { return() }

        let headers: [String: Any] = ["Authorization": "Basic \(authToken)", "Content-Type": "application/json"]

        var params: [String: Any] = ["password": password
            , "email": email
            , "firstname": firstName
            , "lastname": lastName
            , "reCaptcha": recaptchaKey
        ]
        
        if let value = panelID { params["panelID"] = value }
        if let value = gender { params["gender"] = value }
        if let value = postalCode { params["postalCode"] = value }
        if let value = city { params["city"] = value }
        if let value = state { params["state"] = value }
        if let value = country { params["country"] = value }
        if let value = hoID { params["hoID"] = value }
        if let value = aid { params["aid"] = value }
        if let value = referralCode { params["referralCode"] = value }
        if let value = birthDate { params["referralCode"] = Utils().dateFormatter.string(from: value) }

        network?.retrieveData(url: url
            , requestType: .post
            , headerParameters: headers
            , jsonParameters: params
            , callback:
        {
            [weak self ] data, code, headers, error in
            
            guard let strongSelf = self else { return() }
            
            if let data = data as? [String:Any]
            {
                strongSelf.parse(user: strongSelf, dict: data)
                
                if let id = strongSelf.userID
                    , id > 0
                {
                    strongSelf.password = password
                    strongSelf.lastLogin = Date()
                    strongSelf.authStatus = .authenticated
                    strongSelf.saveCredentials()
                    strongSelf.archive()
                }
            }
            
            if strongSelf.authStatus == .authenticated
            {
                for obj in strongSelf.userDelegates.allObjects
                {
                    if let r = obj.userLoginComplete
                    {
                        r()
                    }
                }
            }
            
            completion(error)
        })
    }
    
    
    //    https://stage.pointclub.com/login?auth_key=GFjAeKLXaxWu9W_Nt9Ks2DQKrpzip68P&email=jitesh108@mailinator.com
    
    func login(email: String
        , password: String
        , completion: @escaping (_ error: NSError?) -> ())
    {
        guard let url = Configuration.shared.fetch(configurationProperty: .LoginAPI) as? String
            , let authToken = Configuration.shared.fetch(configurationProperty: .AuthKey) as? String
            , let recaptchaKey = Configuration.shared.fetch(configurationProperty: .RecaptchaKey) as? String
        else { return() }
        
        let params: [String: Any] = ["email": email
            , "password": Data(password.utf8).base64EncodedString()
            , "reCaptcha": recaptchaKey]
        
        let headers: [String: Any] = ["Authorization": "Basic \(authToken)", "Content-Type": "application/json"]
        
        network?.retrieveData(url: url
            , requestType: .post
            , headerParameters: headers
            , jsonParameters: params
            , callback:
        {
            [weak self] data, code, headers, error in
            
            guard let strongSelf = self else { return() }
            
            if let error = error
            {
                completion(error)
                return()
            }
            
            if let data = data as? [String:Any]
            {
                strongSelf.parse(user: strongSelf, dict: data)
                
                if let id = strongSelf.userID
                    , id > 0
                {
                    strongSelf.password = password
                    strongSelf.lastLogin = Date()
                    strongSelf.authStatus = .authenticated
                    strongSelf.saveCredentials()
                    strongSelf.archive()
                }
            }
            
            if strongSelf.authStatus == .authenticated
            {
                for obj in strongSelf.userDelegates.allObjects
                {
                    if let r = obj.userLoginComplete
                    {
                        r()
                    }
                }
            }
            
            completion(error)
        })
    }

    func forgotPassword(email: String, completion: @escaping (_ error: NSError?) -> ())
    {
        guard let url = Configuration.shared.fetch(configurationProperty: .ForgotPasswordAPI) as? String
            , let authToken = Configuration.shared.fetch(configurationProperty: .AuthKey) as? String
            else { return() }
        
        let params: [String: Any] = ["email": email]
        let headers: [String: Any] = ["Authorization": "Basic \(authToken)", "Content-Type": "application/json"]

        network?.retrieveData(url: url
            , requestType: .post
            , headerParameters: headers
            , jsonParameters: params
            , callback:
        {
            [weak self] data, code, headers, error in
            
            guard let _ = self
                else
            {
                return()
            }
            
            completion(error)
        })
    }
    
    func dupeEmailCheck(email: String, isSocial: Bool = false, completion: @escaping (_ error: NSError?) -> ())
    {
        guard let url = Configuration.shared.fetch(configurationProperty: .DupeEmailCheckAPI) as? String
            , let authToken = Configuration.shared.fetch(configurationProperty: .AuthKey) as? String
            else { return() }
        
        let params: [String: Any] = ["scenario": isSocial ? "socialRegister" : "register"]
        let headers: [String: Any] = ["Authorization": "Basic \(authToken)", "Content-Type": "application/json"]
        
        network?.retrieveData(url: String(format: url, email)
            , requestType: .get
            , headerParameters: headers
            , jsonParameters: params
            , callback:
        {
            [weak self] data, code, headers, error in
            
            guard let _ = self
                else
            {
                return()
            }
            
            completion(error)
        })
    }
    
    func facebookCheck(token: String, completion: @escaping (_ isBuhblerUser: Bool?, _ error: NSError?) -> ())
    {
        guard let url = Configuration.shared.fetch(configurationProperty: .FacebookCheckAPI) as? String
            else { return() }
        
        let params: [String: Any] = ["facebook_token": token]
        
        network?.retrieveData(url: url
            , requestType: .post
            , formParameters: params
            , callback:
        {
            [weak self] data, code, headers, error in
            
            guard let strongSelf = self else { return() }

            var isUser: Bool = false
            
            if let data = data as? [String: Any]
            {
                if let body = data["data"] as? [String:Any]
                {
                    if let value = body["is_buhbler_user"] as? Bool { isUser = value }
                }

                if let messages = data["messages"] as? [String]
                    , messages.count > 0
                {
                    let message = messages.joined(separator: "\n")
                    let theError = NSError(domain: Configuration.shared.rootURL(), code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                    completion(isUser, theError)
                    return()
                }

                if isUser
                    , let body = data["data"] as? [String:Any]
                    , let u = body["user"] as? [String:Any]
                {
                    strongSelf.parse(user: strongSelf, dict: u)
                
                    strongSelf.lastLogin = Date()
                    strongSelf.authStatus = .authenticated
                    strongSelf.saveCredentials()
                    strongSelf.archive()
                    
                    if strongSelf.authStatus == .authenticated
                    {
                        for obj in strongSelf.userDelegates.allObjects
                        {
                            if let r = obj.userLoginComplete
                            {
                                r()
                            }
                        }
                    }
                }
            }
            
            completion(isUser, error)
        })
    }

    
    func facebookAuth(token: String, deviceToken: String?, userName: String, completion: @escaping (_ error: NSError?) -> ())
    {
        guard let url = Configuration.shared.fetch(configurationProperty: .FacebookAuthAPI) as? String
            else { return() }
        
        var params: [String: Any] = ["facebook_token": token
            , "username": userName
        ]
        
        if let deviceToken = deviceToken
        {
            params["device_token"] = deviceToken
        }
        
        network?.retrieveData(url: url
            , requestType: .post
            , formParameters: params
            , callback:
        {
            [weak self] data, code, headers, error in
            
            guard let strongSelf = self else { return() }
            
            if let data = data as? [String: Any]
            {
                if let body = data["data"] as? [String:Any]
                    , let u = body["user"] as? [String:Any]
                {
                    strongSelf.parse(user: strongSelf, dict: u)
                }
                
                if let messages = data["messages"] as? [String]
                    , messages.count > 0
                {
                    let message = messages.joined(separator: "\n")
                    let theError = NSError(domain: Configuration.shared.rootURL(), code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                    completion(theError)
                    return()
                }
            }
            
            strongSelf.lastLogin = Date()
            strongSelf.authStatus = .authenticated
            strongSelf.saveCredentials()
            strongSelf.archive()
            
            
            if strongSelf.authStatus == .authenticated
            {
                for obj in strongSelf.userDelegates.allObjects
                {
                    if let r = obj.userLoginComplete
                    {
                        r()
                    }
                }
            }
            
            completion(error)
        })
    }
    


    func twitterCheck(token: String, secret: String, completion: @escaping (_ isBuhblerUser: Bool?, _ error: NSError?) -> ())
    {
        guard let url = Configuration.shared.fetch(configurationProperty: .TwitterCheckAPI) as? String
            else { return() }
        
        let params: [String: Any] = ["twitter_token": token, "twitter_secret": secret]
        
        network?.retrieveData(url: url
            , requestType: .post
            , formParameters: params
            , callback:
        {
            [weak self] data, code, headers, error in
            
            guard let strongSelf = self else { return() }
            
            var isUser: Bool = false
            
            if let data = data as? [String: Any]
            {
                if let body = data["data"] as? [String:Any]
                {
                    if let value = body["is_buhbler_user"] as? Bool { isUser = value }
                }
                
                if let messages = data["messages"] as? [String]
                    , messages.count > 0
                {
                    let message = messages.joined(separator: "\n")
                    let theError = NSError(domain: Configuration.shared.rootURL(), code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                    completion(isUser, theError)
                    return()
                }
                
                if isUser
                    , let body = data["data"] as? [String:Any]
                    , let u = body["user"] as? [String:Any]
                {
                    strongSelf.parse(user: strongSelf, dict: u)
                    
                    strongSelf.lastLogin = Date()
                    strongSelf.authStatus = .authenticated
                    strongSelf.saveCredentials()
                    strongSelf.archive()
                    
                    if strongSelf.authStatus == .authenticated
                    {
                        for obj in strongSelf.userDelegates.allObjects
                        {
                            if let r = obj.userLoginComplete
                            {
                                r()
                            }
                        }
                    }
                }
            }
            
            completion(isUser, error)
        })
    }
    
    
    func twitterAuth(token: String, secret: String, deviceToken: String?, userName: String, completion: @escaping (_ error: NSError?) -> ())
    {
        guard let url = Configuration.shared.fetch(configurationProperty: .TwitterAuthAPI) as? String
            else { return() }
        
        var params: [String: Any] = ["twitter_token": token
            , "username": userName
            , "twitter_secret": secret
        ]
        
        if let deviceToken = deviceToken
        {
            params["device_token"] = deviceToken
        }
        
        network?.retrieveData(url: url
            , requestType: .post
            , formParameters: params
            , callback:
        {
            [weak self] data, code, headers, error in
            
            guard let strongSelf = self else { return() }
            
            if let data = data as? [String: Any]
            {
                if let body = data["data"] as? [String:Any]
                    , let u = body["user"] as? [String:Any]
                {
                    strongSelf.parse(user: strongSelf, dict: u)
                }
                
                if let messages = data["messages"] as? [String]
                    , messages.count > 0
                {
                    let message = messages.joined(separator: "\n")
                    let theError = NSError(domain: Configuration.shared.rootURL(), code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                    completion(theError)
                    return()
                }
            }
            
            strongSelf.lastLogin = Date()
            strongSelf.authStatus = .authenticated
            strongSelf.saveCredentials()
            strongSelf.archive()
            
            
            if strongSelf.authStatus == .authenticated
            {
                for obj in strongSelf.userDelegates.allObjects
                {
                    if let r = obj.userLoginComplete
                    {
                        r()
                    }
                }
            }
            
            completion(error)
        })
    }
    
//{"apiStatus":"success","message":"","panelist":{"id":122021,"enc_pid":"5d529d35f8a75731885466a2","panel_id":2,"email":"parth88965@mailinator.com","clean_email":"parth88965mailinatorcom","mail_sent_count":0,"welcome_email_sent":0,"bounce_email":0,"first_name":"parth","last_name":"QA","gender":"Male","dob":"11-19-1993","points":1000,"lifetime_points":1000,"contact_no":"","street":"","city":"ahmedabad","country":"India","iso_code":"IN","zipcode":"302021","state":"Gujarat","state_code":"","dma_code":"","dma_name":"","county":"","region":"","div":"","status":"st_act","traffic_source":0,"promo_code":"","status_cashout":true,"status_email":true,"status_survey":true,"bypass_status_cron":false,"step":0,"source":"","hoa_id":"","aid":"","offer_id":"","aff_sub":"","google_id":"","facebook_id":"","supplier_id":32,"answers":"","card":"","auth_key":"4lskkRVsm1pSsMkx4WAHvqbLc6RupsFZ","avatar":"","isPasswordSet":"true","email_verified":"not_verified","doi_date":"","surveys_attended":0,"surveys_completed":0,"referral_id":"","user_device":"","created_at":{"sec":1565695285},"lastaction_at":{"sec":1566140212},"updated_at":{"sec":1566140212},"lastvisit_at":{"sec":1565938413},"lastvisit_ip":"","registration_ip":"","truesampleinfo":null,"relevantIdInfo":null,"sweeps_code":"","clubhouse_tour_review":null,"truesample_score_version":0,"daily_streak":{"level":0,"day":0,"daily_streak_date":{"sec":1565695285},"max_day":0,"max_day_date":{"sec":1565695285}},"notes":"","last":"","unsubscribe_date":"","unsubscribe_by":"","status_email_updated_at":"","status_email_updated_by":"","email_verf_snd":"","cshout_speeder":0,"pwd_reset":"","sur_speeder_cnt":"","invalid_txn_cnt":0,"valid_txn_cnt":0,"fb_clk_ovrly":"","fb_cls_ovrly":"","amazon_cls_ovrly":"","pending_bal_cls_ovrly":"","cookie_accepted":"","cookie_accepted_date":"","psqt":"","refer_cnt":0,"pend_pnt":0,"twillo_usr_id":"","redeem_phone_no":0,"dial_code":0,"question_set_step":0,"auth_csrf_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MTIyMDIxLCJlbmNQSUQiOiI1ZDUyOWQzNWY4YTc1NzMxODg1NDY2YTIiLCJyYW5kb21TdHJpbmciOiJkMGJjMDg3OTI3ODdlN2JlMmU3NDk5YTllYzBiOTQ0ZiIsImF1dGhfa2V5IjoiNGxza2tSVnNtMXBTc01reDRXQUh2cWJMYzZSdXBzRloifQ.fH4DZTeEpF_Vo61Nmqmm6AHP4PEMGv0oI3V8iT5ELYk","is_new_pc":1,"onboarding_step":0,"loi":"","profile":{"address":{"street":"","city":"ahmedabad","state":"Gujarat","country":"India","zipcode":"302021","iso_code":"IN"},"name":{"first":"parth","last":"QA"},"gender":"Male","contact_no":"","dob":"11-19-1993"},"consistency_checked":"","comprehension":"","red_herring_1":"","red_herring_2":"","adv_trainingsur_status":0,"panel_signup_bonus":1000,"panel_profile_bonus":1000,"panel_profiling_question_bonus":1000,"child_details":null,"USPSAddressResponse":null,"privacy_policy_accepted_dates":[{"$date":{"$numberLong":"1565695285046"}}],"captcha_result":{"login":{"success":false,"error-codes":["missing-input-response"]}},"profile_sur_dt":"","advTraiAttd":false,"advertiser_id":null}}

    func parse(user: User, dict: [String: Any])
    {
        if let panelist = dict["panelist"] as? [String:Any]
        {
            if let value = panelist["email"] as? String { user.email = value }
            if let value = panelist["first_name"] as? String { user.firstName = value }
            if let value = panelist["last_name"] as? String { user.lastName = value }
            if let value = panelist["auth_key"] as? String { user.authKey = value }

            if let value = panelist["id"] as? Int { user.userID = value }
            if let value = panelist["authKey"] as? String { user.authKey = value }
            if let value = panelist["email_verification_link"] as? String { user.emailVerificationLink = value }
            if let value = panelist["facebook_id"] as? String { user.facebookID = value }
            if let value = panelist["twitter_id"] as? String { user.twitterID = value }

            if let value = dict["gender"] as? String
            {
                var genderType: GenderType = .none
                
                switch value
                {
                case "m":
                    genderType = .male
                case "f":
                    genderType = .female
                default:
                    genderType = .none
                }

                user.genderType = genderType
            }
        }
    }
    
    func parse(dict: [String:Any]) -> User
    {
        let user: User = User()
        
        self.parse(user: user, dict: dict)
        
        return user
    }
}
