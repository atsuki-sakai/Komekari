//
//  ImageLoader.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/09/25.
//

import Foundation
import FirebaseStorage
import Firebase

class ImageLoader {
    
    static func uploadImages(pathType: filePathType,images: [UIImage?], uid: String, completion: @escaping(_ error:Error?, _ imageLinks: [String]) -> Void) {
        
        var imageLinks: [String] = []
        if !Reachabilty.HasConnection(){
            let error = CustomError.notConnection
            completion(error, imageLinks)
        }
        var uploadImagesCount:Int = 0
        var nameSuffix:Int = 0
        for image in images {
            var fileName = pathType.rawValue + "/" + uid + "_\(nameSuffix).jpg"
            guard let imageData = image?.jpegData(compressionQuality: 0.005) else { return print("imagedata is nil") }
            saveImageInFirestore(fileName: fileName, Data: imageData) { (error, imageUrl) in
                if imageUrl != nil {
                    imageLinks.append(imageUrl!)
                    uploadImagesCount += 1
                    if uploadImagesCount == images.count  {
                        print("completed")
                        completion(nil,imageLinks)
                        return
                    }
                }
            }
            nameSuffix += 1
        }
    }
    
    static func saveImageInFirestore(fileName: String,Data: Data, completion: @escaping(_ error: Error?,_ imageLinks: String?) -> Void) {
   
        let metadata = StorageMetadata()
        let storageRef = Storage.storage().reference(withPath: fileName)
        metadata.contentType = "image/jpg"
        storageRef.putData(Data, metadata: metadata, completion: { (meta, error) in
            if let error = error {
                completion(error, nil)
                return
            }
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(error,nil)
                    return
                }
                guard let downLoadURL = url else { return }
                print("downloadURL =>",downLoadURL.absoluteString)
                completion(nil, downLoadURL.absoluteString)
            }

        })
    }
   
    static func downloadImage(ref: StorageRef,uid: String, completion: @escaping(Error?, URL?) -> Void) {
        
        FirebaseStorageRef(ref).child(uid + "_0.jpg").downloadURL { (url, error) in
            if let error = error {
                completion(error, nil)
            }
            guard let url = url else { return }
            completion(nil, url)
        }
    }
}
