//
//  Item.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/12.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Item {
    
    var id: String
    var sellerId: String
    var sellerImage: String
    var sellerName: String
    var itemName: String
    var price: Double
    var inStock: Int
    var images: [String]
    var description: String
    var sellerArea: Int
    
    init(sellerId: String, sellerName: String, sellerImage: String
         , price: Double, inStock: Int, itemName: String, images: [String], description: String, sellerArea: Prefectures.RawValue) {
        
        self.id = UUID().uuidString
        self.sellerId = sellerId
        self.sellerName = sellerName
        self.sellerImage = sellerImage
        self.price = price
        self.inStock = inStock
        self.itemName = itemName
        self.images = images
        self.description = description
        self.sellerArea = sellerArea
    }
    
    init(_dictionary: NSDictionary) {
        
        self.id = _dictionary[kItemID] as? String ?? ""
        self.sellerId = _dictionary[kSellerId] as? String ?? ""
        self.sellerName = _dictionary[kSellerName] as? String ?? ""
        self.sellerImage = _dictionary[kSellerImage] as? String ?? ""
        self.price = _dictionary[kItemPrice] as? Double ?? 0.0
        self.inStock = _dictionary[kInStock] as? Int ?? 0
        self.itemName = _dictionary[kItemName] as? String ?? ""
        self.images = _dictionary[kItemImages] as? [String] ?? []
        self.description = _dictionary[kItemDescription] as? String ?? ""
        self.sellerArea = _dictionary[kSellerArea] as? Int ?? 0
    }
}

func itemDictionaryFrom(item: Item) -> NSDictionary {
    return NSDictionary(objects: [item.sellerId, item.sellerName, item.sellerImage, item.id, item.itemName, item.price, item.inStock, item.images, item.description, item.sellerArea], forKeys: [kSellerId as NSCopying,kSellerName as NSCopying, kSellerImage as NSCopying, kItemID as NSCopying, kItemName as NSCopying, kItemPrice as NSCopying, kInStock as NSCopying,kItemImages as NSCopying, kItemDescription as NSCopying, kSellerArea as NSCopying])
}

