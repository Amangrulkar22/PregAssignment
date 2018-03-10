//
//  Extensions.swift
//  PregAssignment
//
//  Created by Ashwinkumar Mangrulkar on 10/03/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import UIKit
import Foundation

extension UIImageView {
    
    private struct AssociatedKeys {
        static var filePath = ""
    }
    
    var filePath : String? {
        get {
            guard let path = objc_getAssociatedObject(self, &AssociatedKeys.filePath) as? String else {
                return nil
            }
            return path
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.filePath, newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Download image from url
    ///
    /// - Parameters:
    ///   - urlString: urlstring
    ///   - placeholder: placehoder image
    public func setImageFromUrl(urlString: String, withPlaceholder placeholder: UIImage? = nil) {
        
        image = placeholder
        
        if let url = NSURL(string: urlString) as URL?
        {
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = "\(paths[0])/\(url.path)"
            
            guard FileManager.default.fileExists(atPath: path) == true,
                let data = FileManager.default.contents(atPath: path),
                let image = UIImage(data: data) else {
                    downloadImageFromUrl(url, completion: { [weak self] (completed, image) -> Void in
                        
                        guard let strongSelf = self else { return }
                        
                        UIView.transition(with: self!, duration: 0.2, options: .transitionCrossDissolve, animations: {
                            strongSelf.image = image
                        }, completion: { (completed) in
                            
                        })
                    })
                    
                    return
            }
            
            UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.image = image
            }, completion: { (completed) in
                
            })
            
        }    }
    
    /// Set image from url
    ///
    /// - Parameters:
    ///   - urlString: Url string
    ///   - placeholder: placeholder image
    ///   - completion: completion handler
    public func setImageFromUrl(urlString: String, withPlaceholder placeholder: UIImage? = nil, completion: @escaping (_ completed: Bool, _ image: UIImage?) -> Void) {
        
        image = placeholder
        
        if let url = NSURL(string: urlString) as URL? {
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = "\(paths[0])/\(url.path)"
            
            guard FileManager.default.fileExists(atPath: path) == true,
                let data = FileManager.default.contents(atPath: path),
                let image = UIImage(data: data) else {
                    downloadImageFromUrl(url, completion: { (completed, image) in
                        completion(completed, image)
                    })
                    return
            }
            
            completion(true, image)
        }
    }
    
    /// Download image from url
    ///
    /// - Parameters:
    ///   - url: url string
    ///   - completion: completion handler
    private func downloadImageFromUrl(_ url: URL, completion: @escaping (_ completed: Bool, _ image: UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                if let _ = response
                {
                    var filePath = ""
                    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    
                    filePath = "\(paths[0])/\(url.path)"
                    
                    self.filePath = filePath
                    
                    let url = URL(fileURLWithPath: self.filePath!, isDirectory: false)
                    if let data = data {
                        DispatchQueue.global(qos: .background).async {
                            
                            let image = UIImage(data: data)
                            try? data.write(to: url)
                            
                            DispatchQueue.main.async(){
                                completion(true, image)
                            }
                        }
                    }
                }
            } else {
                completion(false, nil)
            }
        }).resume()
    }
}
