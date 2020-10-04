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
    
    static func saveToAddress(userId: String, address: Address, completion: @escaping(Error?) -> Void){
        
        FirebaseCollectionRef(.Address).document(userId).setData(addressFromDictionary(address: address) as! [String : Any]) { (error) in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
    static func saveItemToFireStore(_ item: Item, completion: @escaping(Error?) -> Void) {
        
        FirebaseCollectionRef(.Item).document(item.id).setData(itemDictionaryFrom(item: item) as! [String : Any]) { (error) in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
    
    static func fetchAllItems(completion: @escaping(Error?, [Item]) -> Void) {
        
        FirebaseCollectionRef(.Item).getDocuments { (snapShot, error) in
            
            var allItem: [Item] = []
            if let error = error {
               completion(error, allItem)
            }
            guard let documents = snapShot?.documents else { return completion(nil,allItem)}
            documents.forEach { (itemDictionary) in
                print(itemDictionary.data())
                allItem.append(Item(_dictionary: itemDictionary.data() as NSDictionary))
                
            }
            completion(nil, allItem)
        }
    }
}
