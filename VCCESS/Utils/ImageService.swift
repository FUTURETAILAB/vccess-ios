import UIKit

class ImageService
{
    private let mapName = "mapName.json"
    private var map: [String:[String:Date]] = [:]
    
    static let shared = ImageService()
    
    typealias ImageServiceCompletion = ((_ image: UIImage?, _ immediate: Bool?, _ error: NSError?) -> Swift.Void)
    
//    var images: [String: Any?] = [:]
    
    var imageBlocks: [String: [ImageServiceCompletion]] = [:]
    
    public static let ImageLoadedNotification: String = "ImageLoadedNotification"
    
    init()
    {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            var mapURL = url
            mapURL.appendPathComponent(self.mapName)
            
            if let dict = NSKeyedUnarchiver.unarchiveObject(withFile: mapURL.path) as? [String:[String:Date]]
            {
                self.map = dict
                
                for key in self.map.keys
                {
                    if let d = self.map[key]
                    {
                        for k in d.keys
                        {
                            var imageURL = url
                            imageURL.appendPathComponent(k)

                            //  If images are older than 14 days - delete them.  We don't want to fill up the user's phone with old images
                            if let date = d[k]
                                , let monthAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date())
                            {
                                if date.compare(monthAgo) == .orderedAscending
                                {
                                    do
                                    {
                                        try FileManager.default.removeItem(at: imageURL)
                                    }
                                    catch
                                    {
                                        print(error)
                                    }
                                    
                                    self.map.removeValue(forKey: key)
                                    
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }    
    
    func image(url: String, progress: ((_ value: Float) -> ())? = nil, completionHandler: ImageServiceCompletion? = nil)
    {
        if let dict = self.map[url]
            , dict.keys.count == 1
            , let fileName = dict.keys.first
            , let image = self.imageFromDisk(fileName: fileName)
        {
            completionHandler?(image, true, nil)
            return()
        }
        
        if let completionHandler = completionHandler
        {
            if imageBlocks[url] == nil
            {
                imageBlocks[url] = [completionHandler]
            }
            else
            {
                imageBlocks[url]?.append(completionHandler)
                return()
            }
        }
        else
        {
            if imageBlocks[url] == nil
            {
                imageBlocks[url] = [{ _,_,_ in }]
            }
            else
            {
                return()
            }
        }
        
        Network.shared.retrieveProgressData(url: url, requestType: .get, progress:
        {
            value in
            
            if let progress = progress
            {
                progress(value)
            }
            
        }, callback:
        {
            [weak self] data, statusCode, responseHeaders, error in
            
            guard let strongSelf = self
                else
            {
                return()
            }

            if let image = data as? UIImage
            {
                strongSelf.saveLocally(path: url, image: image)
                
                if let blocks = strongSelf.imageBlocks[url]
                    , blocks.count > 0
                {
                    while let block = strongSelf.imageBlocks[url]?.removeFirst()
                    {
                        block(image, false, nil)
                        
                        if strongSelf.imageBlocks[url] == nil
                        {
                            break
                        }
                        
                        if strongSelf.imageBlocks[url]?.count == 0
                        {
                            break
                        }
                    }
                }

//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ImageService.ImageLoadedNotification), object: url)
            }
            else
            {
                if let blocks = strongSelf.imageBlocks[url]
                    , blocks.count > 0
                {
                    while let block = strongSelf.imageBlocks[url]?.removeFirst()
                    {
                        block(nil, false, error)
                        
                        if strongSelf.imageBlocks[url] == nil
                        {
                            break
                        }
                        
                        if strongSelf.imageBlocks[url]?.count == 0
                        {
                            break
                        }
                    }
                }
            }
        })
    }
    
    func documentPath(url: String) -> String?
    {
        var doc: String?
        
        if let dict = self.map[url]
            , dict.keys.count == 1
            , let fileName = dict.keys.first
            , var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            url.appendPathComponent(fileName)
            doc = url.absoluteString
        }
        
        return doc
    }
    
    func fetchImage(url: String) -> UIImage?
    {
        var image: UIImage?
        
        if let dict = self.map[url]
            , dict.keys.count == 1
            , let fileName = dict.keys.first
            , let img = self.imageFromDisk(fileName: fileName)
        {
            image = img
        }

        return image
    }
    
    func saveLocally(path: String, image: UIImage)
    {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            let fileName = UUID().uuidString + ".jpg"
            var imageURL = url
            imageURL.appendPathComponent(fileName)

            if let data = image.jpegData(compressionQuality: 1.0)
            {
                do
                {
                    try data.write(to: imageURL)
                    
                    self.map[path] = [fileName:Date()]

                    var mapURL = url
                    mapURL.appendPathComponent(self.mapName)
                    
                    NSKeyedArchiver.archiveRootObject(self.map, toFile: mapURL.path)
                }
                catch
                {
                    print(error)
                }
            }
        }
    }
    
    private func imageFromDisk(fileName: String) -> UIImage?
    {
        var image: UIImage?
        
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            var imageURL = url
            imageURL.appendPathComponent(fileName)
                            
            do
            {
                let data: Data = try Data(contentsOf: imageURL)
                
                if let img = UIImage(data: data)
                {
                    image = img
                }
            }
            catch
            {
                print(error)
            }
        }
        
        return image
    }
    
    func localImage(url: String) -> UIImage?
    {
        var image: UIImage? = nil
        
        if let dict = self.map[url]
            , dict.keys.count == 1
            , let fileName = dict.keys.first
            , let img = self.imageFromDisk(fileName: fileName)
        {
            image = img
        }
        
        return image
    }

}
