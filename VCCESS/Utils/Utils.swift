
import UIKit
import Contacts

enum Segues : String
{
    case showIntro = "sgShowIntro"
    case challenge = "sgChallenge"
    case openMenu = "openMenu"
    case profile = "sgProfile"
    case post = "sgPost"
    case flag = "sgFlag"
    case video = "sgVideo"
    case gridToPostTable = "sgGridToPostTable"
    case editPost = "sgEditPost"
    case exhibits = "sgExhibits"
    case messages = "sgMessages"
    case notifications = "sgNotifications"
    case about = "sgAbout"
    case termsOfService = "sgTermsOfService"
    case privacy = "sgPrivacy"
    case conduct = "sgConduct"
    case contact = "sgContact"
    case savePost = "sgSavePost"
    case imageSource = "sgImageSource"
    case admin = "sgAdmin"
    case finishFacebook = "sgFinishFacebook"
    case thankYou = "sgThankYou"
    case start = "sgStart"
    case settings = "sgSettings"
    case learnMore = "sgLearnMore"
}

class Utils
{
    var dateFormatter: DateFormatter = DateFormatter()
    var displayDateFormatter: DateFormatter = DateFormatter()
    var displayDateTimeFormatter: DateFormatter = DateFormatter()

    init()
    {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        displayDateFormatter.dateFormat = "MMM dd, yyyy"
        displayDateTimeFormatter.dateFormat = "MMM dd, yyyy  HH:mm a"
    }

    class func stringify(json: Any, prettyPrinted: Bool = false) -> String
    {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        
        do
        {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8)
            {
                return string
            }
        }
        catch
        {
            print(error)
        }
        
        return ""
    }
    
    class func displayMessage(title: String?, message: String, viewController: UIViewController, completion: @escaping () -> ())
    {
        DispatchQueue.main.async
        {
            let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertAction.Style.default, handler:
            {
                action in
                
                completion()
            }))
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    
    class func displayMessage(title: String?, message: String, viewController: UIViewController)
    {
        DispatchQueue.main.async
        {
            let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertAction.Style.default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func timeAgoSinceDate(date:Date) -> String
    {
        var value: String = "Unknown"
        
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year, .second], from: date, to: Date())
        
        if let year = components.year
            , year > 0
        {
            if year > 1
            {
                value = "\(year)y"
            }
            else if year == 1
            {
                value = NSLocalizedString("Last Year", comment: "Last Year")
            }
        }
        else if let month = components.month
            , month > 0
        {
            if month > 1
            {
                value = "\(month)m"
            }
            else if month == 1
            {
                value = NSLocalizedString("Last Month", comment: "Last Month")
            }
        }
            
        else if let week = components.weekOfYear
            , week > 0
        {
            if week > 1
            {
                value = "\(week)w"
            }
            else if week == 1
            {
                value = NSLocalizedString("Last Week", comment: "Last week")
            }
        }
        else if let day = components.day
            , day > 0
        {
            if day > 1
            {
                value = "\(day)d"
            }
            else if day == 1
            {
                value = NSLocalizedString("Yesterday", comment: "Yesterday")
            }
        }
        else if let hour = components.hour
            , hour > 0
        {
            if hour > 1
            {
                value = "\(hour)h"
            }
            else if hour == 1
            {
                value = "1h"
            }
        }
        else if let minute = components.minute
            , minute > 0
        {
            if minute > 1
            {
                value = "\(minute)min"
            }
            else if minute == 1
            {
                value = "1m"
            }
        }
        else if let second = components.second
            , second > 0
        {
            if second > 1
            {
                value = "\(second)s"
            }
            else if second == 1
            {
                value = NSLocalizedString("Just Now", comment: "Just Now")
            }
        }
        
        return value
        
    }
    
    class func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.range(of: emailRegEx, options: .regularExpression, range: nil, locale: nil)
        let result = range != nil ? true : false
        return result
    }
    
    
    class func printFonts()
    {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames
        {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }

    class func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String
    {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 13 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 13)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{3})(\\d+)", with: "$1 ($2) $3-$4", options: .regularExpression, range: range)
        }
        
        return number
    }
    
    
    class func phoneEmailJSON(contact: CNContact) -> [String:[String]]?
    {
        var dict: [String:[String]]?
        
        var phones: [String] = []
        var emails: [String] = []
        
        for phone in contact.phoneNumbers
        {
            phones.append(phone.value.stringValue.filter("01234567890".contains))
        }
        
        for email in contact.emailAddresses
        {
            emails.append((email.value as String).lowercased())
        }
        
        if phones.count > 0
            || emails.count > 0
        {
            dict = [:]
            if phones.count > 0 { dict?["phone"] = phones }
            if emails.count > 0 { dict?["email"] = emails }
        }
        
        return dict
    }
}


