import Foundation

enum ConfigurationProperty : String
{
    case CurrentEnvironment = "CurrentEnvironment"
    case AdminPassword = "AdminPassword"
    case Environments = "Environments"
    case LearnMoreURL = "LearnMoreURL"
    
    case PusherAPIKey = "Pusher,APIKey"
    case PusherCluster = "Pusher,Cluster"

    case TwitterSecret = "Twitter,Secret"

    case TermsOfUseURL = "TermsOfUseURL"
    case PrivacyPolicyURL = "PrivacyPolicyURL"
    case AuthKey = "AuthKey"
    case RecaptchaKey = "RecaptchaKey"
    case WebviewURL = "WebviewURL"
    
    case AppInitAPI = "APIs,AppInitAPI"
    
    case RegisterAPI = "APIs,RegisterAPI"
    case LoginAPI = "APIs,LoginAPI"
    case ForgotPasswordAPI = "APIs,ForgotPasswordAPI"
    case DupeEmailCheckAPI = "APIs,DupeEmailCheckAPI"
    
    case UserAvatarAPI = "APIs,UserAvatarAPI"
    case ProfileAPI = "APIs,ProfileAPI"
    case UpdateUserAPI = "APIs,UpdateUserAPI"
    case UpdatePasswordAPI = "APIs,UpdatePasswordAPI"
    case FacebookCheckAPI = "APIs,FacebookCheckAPI"
    case FacebookAuthAPI = "APIs,FacebookAuthAPI"
    case TwitterCheckAPI = "APIs,TwitterCheckAPI"
    case TwitterAuthAPI = "APIs,TwitterAuthAPI"
    case VerifyPhoneAPI = "APIs,VerifyPhoneAPI"
    case ResendPhoneCodeAPI = "APIs,ResendPhoneCodeAPI"
    
}

class Configuration
{
    static let shared = Configuration()
    let server: String = "http://buhbler.com"

    var currentConfig: [AnyHashable:Any] = [:]

    init()
    {
        if let value = UserDefaults.standard.string(forKey: "CurrentEnvironment")
        {
            if value.compare("QA") == .orderedSame
            {
                loadData(data: self.qaData())
            }
            else if value.compare("Production") == .orderedSame
            {
                loadData(data: self.prodData())
            }
            else if value.compare("Development") == .orderedSame
            {
                loadData(data: self.devData())
            }
//            else if value.compare("Staging") == .orderedSame
//            {
//                loadData(data: self.stagingData())
//            }

            UserDefaults.standard.set(self.fetch(configurationProperty: .CurrentEnvironment), forKey: ConfigurationProperty.CurrentEnvironment.rawValue)
            UserDefaults.standard.synchronize()
        }
        else
        {
            //  This is where we tell the app which environment to default to.
            loadData(data: self.prodData())
            UserDefaults.standard.set(self.fetch(configurationProperty: .CurrentEnvironment), forKey: "CurrentEnvironment")
            UserDefaults.standard.synchronize()
        }
    }

    func fetch(configurationProperty: ConfigurationProperty) -> Any?  //(args: String) -> Any?
    {
        var value: Any?

        let arrArgs = configurationProperty.rawValue.components(separatedBy: ",")
        var config: [AnyHashable:Any] = self.currentConfig
        
        for i in 0..<arrArgs.count
        {
            value = config[arrArgs[i]]
            if let newConfig = value as? [AnyHashable:Any]
            {
                config = newConfig
            }
        }
        
        
        return value
    }
    
    subscript(key: String) -> Any?
    {
        get
        {
            return currentConfig[key]
        }
        
        set
        {
            currentConfig[key] = newValue as Any
        }
    }
    
    func rootURL() -> String
    {
        return self.server
    }
    
    func loadConfig(environment: String, completionHandler: @escaping (_ error: NSError?) -> ())
    {
        if let dict = self["Environments"] as? [String:Any]
            , let env = dict[environment] as? [String:Any]
            , let url = env["ConfigURL"] as? String
        {
            Network.shared.retrieveData(url: url, requestType: .get, callback:
            {
                [weak self] data, statusCode, responseHeaders, error in

                guard let strongSelf = self
                    else
                {
                    return()
                }

                if let error = error
                {
                    completionHandler(error)
                    return()
                }
                
                if let data = data as? [String:Any]
                {
                    strongSelf.loadData(data: data)
                    strongSelf["CurrentEnvironment"] = environment
                }

                completionHandler(nil)
            })
        }
        else
        {
            completionHandler(nil)
        }
    }
    
    func environments() -> [String]
    {
        var values: [String] = []
        
        if let dict = self.currentConfig[ConfigurationProperty.Environments.rawValue] as? [String:[String:String]]
        {
            for d in dict.keys
            {
                values.append(d)
            }
        }
        
        return values
    }
    
    func changeEnvironment(environment: String)
    {
        if environment.compare("Production") == .orderedSame
        {
            self.currentConfig = self.prodData()
        }
        else if environment.compare("QA") == .orderedSame
        {
            self.currentConfig = self.qaData()
        }
        else if environment.compare("Development") == .orderedSame
        {
            self.currentConfig = self.devData()
        }
//        else if environment.compare("Staging") == .orderedSame
//        {
//            self.currentConfig = self.stagingData()
//        }

        UserDefaults.standard.set(self.fetch(configurationProperty: .CurrentEnvironment), forKey: "CurrentEnvironment")
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func loadData(data: [String:Any])
    {
        self.currentConfig.removeAll()
        
        for key in data.keys
        {
            self[key] = data[key]
        }
        
    }
    
    private func prodData() -> [String:Any]
    {
        let dict: [String:Any] = [
            "CurrentEnvironment": "Production"
            , "Environments":["Production":["ConfigURL":"http://unshuttered.org/api/1/configuration"]
                ,"Development":["ConfigURL":"http://localhost:3000/api/1/configuration"]
//                ,"Staging":["ConfigURL":"http://stage.unshuttered.com.org/api/1/configuration"]
                ,"QA":["ConfigURL":"http://34.209.188.245:3000/api/1/configuration"]
            ]
            , "AdminPassword":"12151892"
            , "RecaptchaKey": "2!QUs6YErH3GN8+kQ&JJY9q"
            , "ImageBaseURL": ""
            , "LearnMoreURL": "https://unshuttered.org/challenges/%@/learn_more?app=true"

            , "Pusher":["APIKey": "a71c7b71a874376d4183", "Cluster": "us2"]
            , "Twitter":["Secret": "BhmnSfSjTHKUad0fzkhgoLdQlAs6edMmOUAVl1aCKe0hc"]
            
            ,"TermsOfUseURL": "https://policies.google.com/terms"
            ,"PrivacyPolicyURL": "https://policies.google.com/privacy"
            , "WebviewURL": "https://stage.pointclub.com/login?auth_key=%@&email=%@"

            , "AuthKey": "SmRpY2RleEFLbloyNUFCckt4aS1yanJVNkotWW8tZXM6MWZhNTk2YzIyY2Uw"
            
            , "APIs": [
                 "RegisterAPI": "http://panel3api.pointclub.com/api/web/JdicdexAKnZ25ABrKxi-rjrU6J-Yo-es/v1/panelists"
                , "LoginAPI": "http://panel3api.pointclub.com/api/web/JdicdexAKnZ25ABrKxi-rjrU6J-Yo-es/v1/panelists/login"
                , "DupeEmailCheckAPI": "http://panel3api.pointclub.com/api/web/JdicdexAKnZ25ABrKxi-rjrU6J-Yo-es/v1/panelists/email/%@"
//                , "ProfileAPI": "https://www.buhbler.com/api/user/get"
//                , "UserAvatarAPI": "https://www.buhbler.com/api/user/uploadavatar"
//                , "AppInitAPI": "https://www.buhbler.com/api/user/init"
                , "ForgotPasswordAPI": "https://panel3api.pointclub.com/api/web/JdicdexAKnZ25ABrKxi-rjrU6J-Yo-es/v1/panelists/forgotpassword"
//                , "UpdateUserAPI": "https://www.buhbler.com/api/user/set"
//                , "UpdatePasswordAPI": "https://www.buhbler.com/api/user/updatepassword"
//                , "FacebookCheckAPI": "https://www.buhbler.com/api/user/facebookcheck"
//                , "FacebookAuthAPI": "https://www.buhbler.com/api/user/facebookauth"
//                , "TwitterCheckAPI": "https://www.buhbler.com/api/user/twittercheck"
//                , "TwitterAuthAPI": "https://www.buhbler.com/api/user/twitterauth"
//                , "VerifyPhoneAPI": "https://www.buhbler.com/api/user/verifyphone"
//                , "ResendPhoneCodeAPI": "https://www.buhbler.com/api/user/resendphoneverificationcode"
            ]
        ]
        
        return dict
    }

    private func devData() -> [String:Any]
    {
        let dict: [String:Any] = [
            "CurrentEnvironment": "Development"
            ,"Environments":["Production":["ConfigURL":"http://unshuttered.org/api/1/configuration"]
                ,"Development":["ConfigURL":"http://localhost:3000/api/1/configuration"]
//                ,"Staging":["ConfigURL":"http://stage.unshuttered.com.org/api/1/configuration"]
                ,"QA":["ConfigURL":"http://34.209.188.245:3000/api/1/configuration"]
            ]
            ,"AdminPassword":"12151892"
            , "RecaptchaKey": "2!QUs6YErH3GN8+kQ&JJY9q"
            ,"ImageBaseURL": "http://localhost:3000"
            ,"LearnMoreURL": "http://localhost:3000/challenges/%@/learn_more?app=true"

            , "Pusher":["APIKey": "a71c7b71a874376d4183", "Cluster": "us2"]
            , "Twitter":["Secret": "BhmnSfSjTHKUad0fzkhgoLdQlAs6edMmOUAVl1aCKe0hc"]

            ,"TermsOfUseURL": "https://policies.google.com/terms"
            ,"PrivacyPolicyURL": "https://policies.google.com/privacy"
            , "WebviewURL": "https://stage.pointclub.com/login?auth_key=%@&email=%@"

            , "AuthKey": "SmRpY2RleEFLbloyNUFCckt4aS1yanJVNkotWW8tZXM6MWZhNTk2YzIyY2Uw"

            , "APIs": [
                "RegisterAPI": "http://panel3api.pointclub.com/api/web/JdicdexAKnZ25ABrKxi-rjrU6J-Yo-es/v1/panelists"
                , "LoginAPI": "http://panel3api.pointclub.com/api/web/JdicdexAKnZ25ABrKxi-rjrU6J-Yo-es/v1/panelists/login"
                , "DupeEmailCheckAPI": "http://panel3api.pointclub.com/api/web/JdicdexAKnZ25ABrKxi-rjrU6J-Yo-es/v1/panelists/email/%@"
//                , "ProfileAPI": "https://dev.buhbler.com/api/user/get"
//                , "UserAvatarAPI": "https://dev.buhbler.com/api/user/uploadavatar"
//                , "AppInitAPI": "https://dev.buhbler.com/api/user/init"
                , "ForgotPasswordAPI": "https://panel3api.pointclub.com/api/web/JdicdexAKnZ25ABrKxi-rjrU6J-Yo-es/v1/panelists/forgotpassword"
//                , "UpdateUserAPI": "https://dev.buhbler.com/api/user/set"
//                , "UpdatePasswordAPI": "https://dev.buhbler.com/api/user/updatepassword"
//                , "FacebookCheckAPI": "https://dev.buhbler.com/api/user/facebookcheck"
//                , "FacebookAuthAPI": "https://dev.buhbler.com/api/user/facebookauth"
//                , "TwitterCheckAPI": "https://dev.buhbler.com/api/user/twittercheck"
//                , "TwitterAuthAPI": "https://dev.buhbler.com/api/user/twitterauth"
//                , "VerifyPhoneAPI": "https://dev.buhbler.com/api/user/verifyphone"
//                , "ResendPhoneCodeAPI": "https://dev.buhbler.com/api/user/resendphoneverificationcode"

            ]
        ]
        
        return dict
    }
    
    private func qaData() -> [String:Any]
    {
        let dict: [String:Any] = [
            "CurrentEnvironment": "QA"
            ,"Environments":["Production":["ConfigURL":"http://unshuttered.org/api/1/configuration"]
                ,"Development":["ConfigURL":"http://localhost:3000/api/1/configuration"]
//                ,"Staging":["ConfigURL":"http://stage.unshuttered.com.org/api/1/configuration"]
                ,"QA":["ConfigURL":"http://34.209.188.245:3000/api/1/configuration"]
            ]
            ,"AdminPassword":"12151892"
            , "RecaptchaKey": "2!QUs6YErH3GN8+kQ&JJY9q"
            ,"ImageBaseURL": "http://34.209.188.245:3000"
            ,"LearnMoreURL": "http://34.209.188.245:3000/challenges/%@/learn_more?app=true"

            , "Pusher":["APIKey": "a71c7b71a874376d4183", "Cluster": "us2"]
            , "Twitter":["Secret": "BhmnSfSjTHKUad0fzkhgoLdQlAs6edMmOUAVl1aCKe0hc"]

            ,"TermsOfUseURL": "https://policies.google.com/terms"
            ,"PrivacyPolicyURL": "https://policies.google.com/privacy"
            , "WebviewURL": "https://stage.pointclub.com/login?auth_key=%@&email=%@"

            , "AuthKey": "SmRpY2RleEFLbloyNUFCckt4aS1yanJVNkotWW8tZXM6MWZhNTk2YzIyY2Uw"

            , "APIs": [
                "RegisterAPI": "http://panel3api.pointclub.com/api/web/JdicdexAKnZ25ABrKxi-rjrU6J-Yo-es/v1/panelists"
                , "LoginAPI": "http://panel3api.pointclub.com/api/web/JdicdexAKnZ25ABrKxi-rjrU6J-Yo-es/v1/panelists/login"
                , "DupeEmailCheckAPI": "http://panel3api.pointclub.com/api/web/JdicdexAKnZ25ABrKxi-rjrU6J-Yo-es/v1/panelists/email/%@"
//                , "ProfileAPI": "https://qa.buhbler.com/api/user/get"
//                , "UserAvatarAPI": "https://qa.buhbler.com/api/user/uploadavatar"
//                , "AppInitAPI": "https://qa.buhbler.com/api/user/init"
                , "ForgotPasswordAPI": "https://panel3api.pointclub.com/api/web/JdicdexAKnZ25ABrKxi-rjrU6J-Yo-es/v1/panelists/forgotpassword"
//                , "UpdateUserAPI": "https://qa.buhbler.com/api/user/set"
//                , "UpdatePasswordAPI": "https://qa.buhbler.com/api/user/updatepassword"
//                , "FacebookCheckAPI": "https://qa.buhbler.com/api/user/facebookcheck"
//                , "FacebookAuthAPI": "https://qa.buhbler.com/api/user/facebookauth"
//                , "TwitterCheckAPI": "https://qa.buhbler.com/api/user/twittercheck"
//                , "TwitterAuthAPI": "https://qa.buhbler.com/api/user/twitterauth"
//                , "VerifyPhoneAPI": "https://qa.buhbler.com/api/user/verifyphone"
//                , "ResendPhoneCodeAPI": "https://qa.buhbler.com/api/user/resendphoneverificationcode"

            ]
        ]
        
        return dict
    }


}
