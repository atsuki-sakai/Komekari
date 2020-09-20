//
//  FireAPI.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/03.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import Firebase
import FirebaseStorage

enum IconSize: Int, CustomStringConvertible {
    
    case small
    case medium
    case large
    
    var description: String {
        
        switch self {
        case .small: return "_100x100"
        case .medium: return "_200x200"
        case .large: return "_400x400"
        }
    }

}

class FireAPI {
    
    static let shared = FireAPI()
    
    func uploadImages(images: [UIImage], uid: String, compression: CGFloat = 0.1, completion: @escaping(_ error: Error?, _ urls: [URL]?) -> Void) {
        
        
        var results: [URL] = []
        var task: StorageUploadTask!
        let meta = StorageMetadata()
        
        meta.contentType = "image/jpeg"
        
        images.forEach { (image) in
            
            guard let imageData = image.jpegData(compressionQuality: compression) else { return }
            task = KSTORAGE_ICONS.child(uid).putData(imageData, metadata: meta, completion: { (metadata, error) in
                
                if let error = error {
                    completion(error, nil)
                }
                task.removeAllObservers()
                KSTORAGE_ICONS.child(uid).downloadURL { (url, error) in
                    
                    if let error = error {
                        completion(error,nil)
                    }
                    guard let url = url else { return }
                    results.append(url)
                }
            })
            task.resume()
        }
        completion(nil, results)
    }
    
    func uploadImage(image: UIImage, uid: String, compression: CGFloat = 0.05, completion: @escaping(_ error: Error?, _ url: String?) -> Void) {
        
        var task: StorageUploadTask!
        let meta = StorageMetadata()
        
        meta.contentType = "image/jpeg"
        guard let imageData = image.jpegData(compressionQuality: compression) else { return }
        task = KSTORAGE_ICONS.child(uid).putData(imageData, metadata: meta, completion: { (metadata, error) in
            
            if let error = error {
                completion(error, nil)
            }
            task.removeAllObservers()
            
            KSTORAGE_ICONS.child(uid).downloadURL { (url, error) in

                if let error = error {
                    completion(error,nil)
                }
                guard let url = url else { return }
                completion(nil, url.absoluteString)
            }
        })
        task.resume()
    }
    
    func downloadThumbnails(uid: String, IconSize: IconSize, completion: @escaping(Error?, URL?) -> Void) {
        
        KSTORAGE_THUMBNAILS.child(uid + IconSize.description).downloadURL { (url, error) in
            
            if let error = error {
                completion(error, nil)
            }
            completion(nil, url)
        }
    }
    
}
