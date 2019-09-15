
import UIKit

class ActivityManager
{
    static let shared = ActivityManager()
    
    var activityCount = 0

    func incrementActivityCount(isVisible: Bool = true)
    {
        ActivityManager.shared.activityCount += 1
        
        if ActivityManager.shared.activityCount == 1
        {
            DispatchQueue.main.async {
                self.showLoadingScreen(isVisible: isVisible)
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
    }
    
    func decrementActivityCount()
    {
        ActivityManager.shared.activityCount -= 1
        
        if ActivityManager.shared.activityCount < 1
        {
            ActivityManager.shared.activityCount = 0
            
            DispatchQueue.main.async {
                self.dismissLoadingWindow()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    fileprivate func dismissLoadingWindow()
    {
        UIApplication.shared.endIgnoringInteractionEvents()
        
        for v : UIView in (UIApplication.shared.keyWindow?.subviews)!
        {
            if v.tag == 9999
            {
                v.removeFromSuperview()
            }
        }
    }
    
    fileprivate func showLoadingScreen(isVisible: Bool = true)
    {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let screenRect : CGRect = UIScreen.main.bounds
        let loadingScreen : UIView = UIView(frame: screenRect)
        loadingScreen.tag = 9999
        loadingScreen.backgroundColor = UIColor.black
        loadingScreen.alpha = isVisible ? 0.5 : 0.0
        loadingScreen.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        
        UIApplication.shared.keyWindow?.addSubview(loadingScreen)

        if isVisible
        {
            let activity : UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            activity.center = loadingScreen.center
            loadingScreen.addSubview(activity)
            activity.startAnimating()
            activity.autoresizingMask = [UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        }
    }
    
}
