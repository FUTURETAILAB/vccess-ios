

import UIKit

extension UIImage
{
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1))
    {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    public func rounded(radius: CGFloat) -> UIImage
    {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    func resize(scale:CGFloat)-> UIImage
    {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var image = UIImage()
        
        if let r = result
        {
            image = r
        }
        
        return image
    }
    
    func resizeToWidth(width:CGFloat)-> UIImage
    {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var image = UIImage()
        
        if let r = result
        {
            image = r
        }
        
        return image
    }
    
    func resizeToSize(size : CGSize)-> UIImage
    {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var image = UIImage()
        
        if let r = result
        {
            image = r
        }
        
        return image
    }
    
    func cropCenter() -> UIImage?
    {
        if self.size.width == self.size.height
        {
            return self
        }
        
        let side: CGFloat = min(self.size.width, self.size.height)
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        if self.size.width > self.size.height
        {
            x = (self.size.width - side)/2
        }
        else if self.size.height > self.size.width
        {
            y = (self.size.height - side)/2
        }
        
        let rect = CGRect(x: x, y: y, width: side, height: side)
        
        let img = self.crop(rect: rect)
        
        return img
    }
    
    func crop( rect: CGRect) -> UIImage?
    {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale

        if rect.origin.x + rect.size.width > self.size.width
            || rect.origin.y + rect.size.height > self.size.height
        {
            return nil
        }
        
        var image: UIImage?
        
        if let cg = self.cgImage
            , let imageRef = cg.cropping(to: rect)
        {
            image = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        }

        return image
    }
    
    func grayscaleImage() -> UIImage?
    {
        var img: UIImage?
        
        if let ciImage = CIImage(image: self)
        {
            let grayscale = ciImage.applyingFilter("CIColorControls", parameters: [ kCIInputSaturationKey: 0.0 ])
            img = UIImage(ciImage: grayscale)
        }
        
        return img
    }
}

