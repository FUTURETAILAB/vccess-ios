import Foundation
import UIKit

enum RequestType : String
{
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

private class NetworkTask
{
    var progressBlock: (_ value: Float) -> () = {v in}
    var completionBlock: (_ data: Any?, _ statusCode: Int, _ responseHeaders : [String:Any]?, _ error: NSError?) -> () = {d, s, r, e in}
    var buffer: Data = Data()
    var responseHeaders : [String:Any] = [:]
    var httpResponse: HTTPURLResponse?
    var startTime: Date = Date()
}

protocol NetworkProtocol: class
{
    func retrieveData( url: String
    , requestType: RequestType
    , headerParameters: [String:Any]?
    , jsonParameters: [String:Any]?
    , uploadData: Data?
    , queryStringParameters: [String:Any]?
    , formParameters: [String:Any]?
    , callback: @escaping (_ data: Any?, _ statusCode: Int, _ responseHeaders : [String:Any]?, _ error: NSError?) -> ()
    )
    
    func addParamForMultiPartForm(data: inout Data, key: String, value: String, boundary: String)
}

extension NetworkProtocol
{
    func retrieveData( url: String
        , requestType: RequestType
        , headerParameters: [String:Any]? = nil
        , jsonParameters: [String:Any]? = nil
        , uploadData: Data? = nil
        , queryStringParameters: [String:Any]? = nil
        , formParameters: [String:Any]? = nil
        , callback: @escaping (_ data: Any?, _ statusCode: Int, _ responseHeaders : [String:Any]?, _ error: NSError?) -> ()
    )
    {
        self.retrieveData(url: url
            , requestType: requestType
            , headerParameters: headerParameters
            , jsonParameters: jsonParameters
            , uploadData: uploadData
            , queryStringParameters: queryStringParameters
            , formParameters: formParameters
            , callback: { data, code, headers, error in callback(data, code, headers, error)})
    }
}

class Network: NSObject, NetworkProtocol
{
    public static let shared = Network()
    private var session: URLSession?
    private var tasks: [URLSessionDataTask: NetworkTask] = [:]
//    var user: User?

    private let unknownError = NSError(domain: Configuration.shared.rootURL(), code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Unknown Server Error", comment: "")])
    
    override init()
    {
        super.init()
        
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }

    func retrieveProgressData( url: String
        , requestType: RequestType
        , headerParameters: [String:Any]? = nil
        , jsonParameters: [String:Any]? = nil
        , uploadData: Data? = nil
        , queryStringParameters: [String:Any]? = nil
        , formParameters: [String:Any]? = nil
        , progress: ((_ value: Float) -> ())? = nil
        , callback: @escaping (_ data: Any?, _ statusCode: Int, _ responseHeaders : [String:Any]?, _ error: NSError?) -> ()
        )
    {
        if let request = self.request(url: url
            , requestType: requestType
            , headerParameters: headerParameters
            , jsonParameters: jsonParameters
            , uploadData: uploadData
            , queryStringParameters: queryStringParameters
            , formParameters: formParameters
            , callback:
            {
                error in
                
                if let error = error
                {
                    callback(nil, 0, nil, error)
                }
        })
        {
            guard let session = self.session
                else
            {
                return()
            }

            let task = session.dataTask(with: request)
            tasks[task] = NetworkTask()
            
            if let progress = progress
            {
                tasks[task]?.progressBlock = progress
            }
            
            tasks[task]?.completionBlock = callback
            task.resume()
        }
    }
    
    func retrieveData( url: String
        , requestType: RequestType
        , headerParameters: [String:Any]? = nil
        , jsonParameters: [String:Any]? = nil
        , uploadData: Data? = nil
        , queryStringParameters: [String:Any]? = nil
        , formParameters: [String:Any]? = nil
        , callback: @escaping (_ data: Any?, _ statusCode: Int, _ responseHeaders : [String:Any]?, _ error: NSError?) -> ()
        )
    {
        if let request = self.request(url: url
            , requestType: requestType
            , headerParameters: headerParameters
            , jsonParameters: jsonParameters
            , uploadData: uploadData
            , queryStringParameters: queryStringParameters
            , formParameters: formParameters
            , callback:
        {
            error in
            
            if let error = error
            {
                callback(nil, 0, nil, error)
            }
        })
        {
            performRequest(request, callback:
            {
                data, statusCode, responseHeaders, error in

                //  If the user comes back as not authenticated, they might have timed out.  try to login again

//                if let error = error
////                    , let user = self.user
////                    , let requestHeaders = headerParameters
////                    , requestHeaders.count > 1
//                {
////                    if error.localizedDescription.compare("Not Authenticated") == .orderedSame
////                    {
////                        let _ = user.relogin(completionHandler:
////                        {
////                            error in
////
////                            if let error = error
////                            {
////                                callback(nil, 0, nil, error)
////                                return()
////                            }
////
////                            self.performRequest(request as URLRequest, callback:
////                            {
////                                data, statusCode, responseHeaders, error in
////
////                                callback(data, statusCode, responseHeaders, error)
////                            })
////                        })
////
////                        return()
////                    }
//                }

                callback(data, statusCode, responseHeaders, error)
            })
        }
        else
        {
            callback(nil, 0, nil, NSError(domain: Configuration.shared.rootURL(), code: 1, userInfo: [NSLocalizedDescriptionKey:"Bad Request"]))
        }

    }
    
    
    private func request( url: String
        , requestType: RequestType
        , headerParameters: [String:Any]? = nil
        , jsonParameters: [String:Any]? = nil
        , uploadData: Data? = nil
        , queryStringParameters: [String:Any]? = nil
        , formParameters: [String:Any]? = nil
        , callback: @escaping ( _ error: NSError?) -> ()
        ) -> URLRequest?
    {
        var url = url
        
        if let qsp = queryStringParameters
        {
            url = url + "?"
            var first: Bool = true
            
            for key in qsp.keys
            {
                if first
                {
                    first = false
                }
                else
                {
                    url = url + "&"
                }
                
                if let v = qsp[key]
                {
                    let s = String(describing: v)
                    url = url + key + "=" + s
                }
            }
        }

        guard let urlValue = URL(string: url) else
        {
            callback(NSError(domain: Configuration.shared.rootURL(), code: 1, userInfo: [NSLocalizedDescriptionKey:"Bad URL"]))
            return nil
        }
        
        var request : URLRequest = URLRequest(url: urlValue)
        request.httpMethod = requestType.rawValue
        
        if let headers = headerParameters
        {
            add(addAPIHeaders(headers), request: &request)
        }

        if let data = uploadData
        {
            request.httpBody = data
        }
        else if let json = jsonParameters
        {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do
            {
                request.httpBody = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            }
            catch
            {
                callback(NSError(domain: Configuration.shared.rootURL(), code: 1, userInfo: [NSLocalizedDescriptionKey:"Parsing Error"]))
                return nil
            }
        }
        else if let form = formParameters
        {
            var body : String = ""
    
            for key in form.keys
            {
                if let string = form[key] as? String
                {
                    body = body.appendingFormat("%@=%@&", key, String(describing: string))
                }
                else if let value = form[key] as? Int
                {
                    body = body.appendingFormat("%@=%@&", key, String(describing: String(value)))
                }
                else if let strings = form[key] as? [String]
                {
                    for string in strings
                    {
                        body = body.appendingFormat("%@=%@&", key, string)
                    }
                }
                
            }
    
            request.httpBody = body.data(using: .utf8)
        }
        
        return request
        
    }
    
    private func performRequest(_ request: URLRequest, callback: @escaping (_ data: Any?, _ statusCode: Int, _ responseHeaders : Dictionary<String,Any>, _ error: NSError?) -> ())
    {
        guard let session = self.session
        else
        {
            return()
        }

        let task = session.dataTask(with: request, completionHandler:
        {
            data, response, networkError in
            
            self.analyzeResponse(request: request, data: data, response: response, error: networkError, callback:
            {
                data, statusCode, headers, error in
                
                callback(data, statusCode, headers, error)
            })
            
        })
        
        task.resume()
    }
    
    private func analyzeResponse(request: URLRequest
        , data: Data?
        , response: URLResponse?
        , error: Error?
        , callback: @escaping (_ data: Any?, _ statusCode: Int, _ responseHeaders : Dictionary<String,Any>, _ error: NSError?) -> ())
    {

        self.logAPIResults(request, response: response, responseData: data, error: error as NSError?)
        
        var responseHeaders : [String:Any] = [:]
        var statusCode: Int = 0
        
        if let httpResponse = response as? HTTPURLResponse
        {
            responseHeaders = (httpResponse.allHeaderFields as? [String:Any])!
            statusCode = httpResponse.statusCode
        }
        
        if let error = error
        {
            callback(nil, statusCode, responseHeaders, error as NSError?)
            return()
        }
        
        let results = self.responseData(data: data, responseHeaders: responseHeaders)
        
        if let error = results.error
        {
            callback(results.object, statusCode, responseHeaders, error)
            return()
        }
        
        if let httpResponse = response as? HTTPURLResponse
        {
            if httpResponse.statusCode != 200 && httpResponse.statusCode != 201
            {
                var errorString = ""
                
                if let data = results.object as? Data
                    , let string = String(data: data, encoding: .utf8)
                {
                    errorString = string
                }
                else if let string = results.object as? String
                {
                    do
                    {
                        if let encodedData = string.data(using: .utf8)
                        {
                            let attributedOptions : [NSAttributedString.DocumentReadingOptionKey: AnyObject] = [
                                NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue) : NSAttributedString.DocumentType.html as AnyObject,
                                NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): NSNumber(value: String.Encoding.utf8.rawValue)
                            ]
                            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                            errorString = String.init(attributedString.string)
                            
                        }
                    }
                    catch
                    {
                    }
                }
                else
                {
                    errorString = "Unknown Error"
                }
                
                let error = NSError(domain: Configuration.shared.rootURL(), code: 1, userInfo: [NSLocalizedDescriptionKey:errorString])
                callback(nil, statusCode, responseHeaders, error)
                return()
            }
        }
            
        callback(results.object, statusCode, responseHeaders, nil)
//        })
    }
    
    private func add(_ headers : Dictionary<String,Any> , request : inout URLRequest)
    {
        for key in headers.keys
        {
            if let s = headers[key] as? String
            {
                request.addValue(s, forHTTPHeaderField: key)
            }
            else if let s = headers[key] as? Int
            {
                request.addValue(String(s), forHTTPHeaderField: key)
            }
            else if let strings = headers[key] as? [String]
            {
                for s in strings
                {
                    request.addValue(s, forHTTPHeaderField: key)
                }
            }
        }
        
    }
    
    func addParamForMultiPartForm(data: inout Data, key: String, value: String, boundary: String)
    {
        data.append(NSString(format: "--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        data.append(NSString(format: "Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key).data(using: String.Encoding.utf8.rawValue)!)
        data.append(NSString(format: "%@\r\n", value).data(using: String.Encoding.utf8.rawValue)!)
    }
    
    private func addAPIHeaders(_ headers : Dictionary<String,Any>?) -> Dictionary<String,Any>
    {
        var newHeaders : Dictionary<String,Any> = [:]
        
        if let h = headers
        {
            for k in h.keys
            {
                newHeaders[k] = h[k]
            }
        }
        
        newHeaders["AppMetaData"] = metaDataHeader()
        return newHeaders
    }
    
    private func metaDataHeader() -> String
    {
        var header: String = ""
        
        var name: String = ""
        var version: String = ""
        var os: String = ""
        var device: String = ""
        var build: String = ""
        
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let modelCode = withUnsafePointer(to: &systemInfo.machine)
        {
            $0.withMemoryRebound(to: CChar.self, capacity: 1)
            {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        
        if let v = modelCode { device = v }
        
        if let v = Bundle.main.bundleIdentifier { name = v }
        
        if let dictionary = Bundle.main.infoDictionary
        {
            if let v = dictionary["CFBundleShortVersionString"] as? String { version = v }
            if let v = dictionary["CFBundleVersion"] as? String { build = v }
        }
        
        os = UIDevice.current.systemVersion
        
        header = "Device: \(device);OS: \(os);Bundle: \(name);Version: \(version);Build: \(build)"
        
        return header
    }
    
    
    
    private func logAPIResults(_ request: URLRequest, response: URLResponse?, responseData: Data?, error: NSError?)
    {
        print("\n\nAPI CALL")
        
        print("\nMethod: \(request.httpMethod!)")
        
        if let url = request.url
        {
            print("URL: \(url.absoluteString)")
        }
        
        if let headers = request.allHTTPHeaderFields
        {
            var h : Dictionary<String,Any> = [:]
            h = headers
            print("Headers: \(h)")
        }
        
        if let body = request.httpBody
        {
            print("\nRequest Size: \(body.count)")

            if let bodyString = String(data: body, encoding: .utf8)
            {
                print("\nRequest Body:\n\n\(bodyString)")
            }
        }
        
        if let httpResponse = response as? HTTPURLResponse
        {
            print("\nResponse Code: \(httpResponse.statusCode)")
            print("\nResponse headers: \(httpResponse.allHeaderFields)")
            
        }
        
        if let d = responseData
        {
            print("\nResponse Size: \(d.count)")
            
            if let responseBody = NSString(data: d, encoding: String.Encoding.utf8.rawValue) as String?
            {
                print("\nResponse Body:\n\n\(responseBody)")
            }
        }
        else
        {
            print("\nResponse Body:\n\nNOT A STRING")
        }
        
        if let e = error
        {
            print("\n\nError: \(e.localizedDescription)")
        }
    }
    
    private class func apiError(_ dict: Dictionary<String,Any>) -> NSError?
    {
        var err : NSError?
        
//        {"status":"Failed","msg":"Invalid Email Address or Password. You have 2 remaining attempts left."}
        
        if let msg : String = dict["msg"] as? String
            , let status: String = dict["status"] as? String
        {
            if status.lowercased() == "failed"
            {
                err = NSError(domain: Configuration.shared.rootURL(), code: 1, userInfo: [NSLocalizedDescriptionKey:msg])
            }
        }
        else if let msg : String = dict["message"] as? String
            , let status: String = dict["apiStatus"] as? String
            , status.compare("error") == .orderedSame
        {
            err = NSError(domain: Configuration.shared.rootURL(), code: 0, userInfo: [NSLocalizedDescriptionKey:msg])
        }
        else if let msg : String = dict["error"] as? String
        {
            var code: Int = 1
            
            if let c = dict["errorCode"] as? Int
            {
                code = c
            }
            
            err = NSError(domain: Configuration.shared.rootURL(), code: code, userInfo: [NSLocalizedDescriptionKey:msg])
        }
        else if let array = dict["errors"] as? [String]
            , let string = array.first
        {
            err = NSError(domain: Configuration.shared.rootURL(), code: 1, userInfo: [NSLocalizedDescriptionKey:string])
        }
        else if let dict = dict["errors"] as? [String:Any]
        {
            var string: String = ""
            for key in dict.keys
            {
                if let value = dict[key] as? [String]
                {
                    string = string + "\(key) \(value.joined(separator: ","))\n\n"
                }
            }
            
            err = NSError(domain: Configuration.shared.rootURL(), code: 1, userInfo: [NSLocalizedDescriptionKey:string])

        }
        
        return err
    }
    
    public func responseData(data: Data?, responseHeaders: [String:Any]) -> (object: Any?, error: NSError?)
    {
        guard let contentType = responseHeaders["Content-Type"] as? String
            else
        {
            return(nil, NSError(domain: Configuration.shared.rootURL(), code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Missing content type", comment: "Missing content type")]))
        }
        
        var object: Any?
        var returnError: NSError?
        
        if let data = data
            , data.count > 0
        {
            if contentType.lowercased() == "text/html"
                || contentType.lowercased() == "text/html; charset=utf-8"
            {
                if let string = String(data: data, encoding: .utf8)
                {
                    object = string
                }
                else
                {
                    returnError = self.unknownError
                }
            }
            else if contentType.lowercased() == "application/octet-stream"
            {
                if let responseBody = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
                    , let d1: Data = responseBody.data(using: String.Encoding.utf8)
                {
                    object = d1
                }
                else
                {
                    returnError = self.unknownError
                }
            }
            else if contentType.lowercased() == "application/json"
                || contentType.lowercased() == "application/json; charset=utf-8"
            {
                do
                {
                    if let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? Dictionary<String,Any>
                    {
                        if let err = Network.apiError(dict)
                        {
                            returnError = err
                        }
                        
                        object = dict
                    }
                    else if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [[String:Any]]
                    {
                        object = array
                    }
                    else if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String]
                    {
                        object = array
                    }
                    else
                    {
                        object = data
                    }
                }
                catch let caught as NSError
                {
                    print(caught.localizedDescription)
                    returnError = caught
                }
                catch
                {
                    returnError = self.unknownError
                }
            }
            else if contentType.lowercased() == "image/jpeg"
                || contentType.lowercased() == "image/png"
                || contentType.lowercased() == "image/gif"
                || contentType.lowercased() == "image/bmp"
                || contentType.lowercased() == "image/webp"
            {
                object = UIImage(data: data)
            }
            else
            {
                object = data
            }
        }
        else
        {
            returnError = self.unknownError
        }
        
        return (object: object, error: returnError)
    }
//    
//    public func responseData(data: Data?, responseHeaders: [String:Any], completionHandler: @escaping (Any?, NSError?) -> ())
//    {
//        guard let contentType = responseHeaders["Content-Type"] as? String
//            else
//        {
//            completionHandler(nil, NSError(domain: Configuration.shared.rootURL(), code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Missing content type", comment: "Missing content type")]))
//            return()
//        }
//
//        if let data = data
//            , data.count > 0
//        {
//            if contentType.lowercased() == "text/html"
//                || contentType.lowercased() == "text/html; charset=utf-8"
//            {
//                if let string = String(data: data, encoding: .utf8)
//                {
//                    completionHandler(string, nil)
//                }
//                else
//                {
//                    completionHandler(nil, self.unknownError)
//                }
//            }
//            else if contentType.lowercased() == "application/octet-stream"
//            {
//                if let responseBody = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
//                    , let d1: Data = responseBody.data(using: String.Encoding.utf8)
//                {
//                    completionHandler(d1, nil)
//                    return()
//                }
//                else
//                {
//                    completionHandler(nil, self.unknownError)
//                }
//            }
//            else if contentType.lowercased() == "application/json"
//                || contentType.lowercased() == "application/json; charset=utf-8"
//            {
//                do
//                {
//                    if let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? Dictionary<String,Any>
//                    {
//                        if let err = Network.apiError(dict)
//                        {
//                            completionHandler(nil, err)
//                            return()
//                        }
//                        
//                        completionHandler(dict, nil)
//                    }
//                    else if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [[String:Any]]
//                    {
//                        completionHandler(array, nil)
//                    }
//                    else if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String]
//                    {
//                        completionHandler(array, nil)
//                    }
//                    else
//                    {
//                        completionHandler(data, nil)
//                    }
//                }
//                catch let caught as NSError
//                {
//                    print(caught.localizedDescription)
//                    completionHandler(nil, caught)
//                }
//                catch
//                {
//                    completionHandler(nil, self.unknownError)
//                }
//            }
//            else if contentType.lowercased() == "image/jpeg"
//                || contentType.lowercased() == "image/png"
//                || contentType.lowercased() == "image/gif"
//                || contentType.lowercased() == "image/bmp"
//                || contentType.lowercased() == "image/webp"
//            {
//                completionHandler(UIImage(data: data), nil)
//            }
//            else
//            {
//                completionHandler(data,nil)
//                
//                
////                completionHandler(nil, NSError(domain: Configuration.shared.rootURL(), code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Unknown content type", comment: "Unknown content type")]))
//            }
//        }
//        else
//        {
//            completionHandler(nil, self.unknownError)
//        }
//    }
}

extension Network: URLSessionDataDelegate, URLSessionDelegate, URLSessionTaskDelegate
{
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        if let httpResponse = response as? HTTPURLResponse
        {
            if let nt = tasks[dataTask]
            {
                nt.httpResponse = httpResponse
                
                if let headers = httpResponse.allHeaderFields as? [String:Any]
                {
                    nt.responseHeaders = headers
                }
                
            }
        }
        
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    {
        if let nt = tasks[dataTask]
        {
            nt.buffer.append(data)
            let value: Float = Float(dataTask.countOfBytesReceived)/Float(dataTask.countOfBytesExpectedToReceive)
            nt.progressBlock(value)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        if let t = task as? URLSessionDataTask
            , let nt = tasks[t]
        {
            if let error = error as NSError?
            {
                nt.completionBlock(nil, -1, nil, error)
                return()
            }
            
            if let request = task.originalRequest
                , let response = nt.httpResponse
            {
                self.analyzeResponse(request: request, data: nt.buffer, response: response, error: error, callback:
                {
                    data, statusCode, headers, error in
                    
                    nt.completionBlock(data, statusCode, headers, error)
                    self.tasks.removeValue(forKey: t)
                })
            }
        }
    }
}
