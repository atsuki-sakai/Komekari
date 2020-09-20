//
//  Item.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/12.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import Foundation

class Item {
    
    var price: Double!
    var inStock: Int!
    var itemName: String!
    var sellerName: String!
    var sellerImage: String!
    var address: Address!
    var images: [String]!
    var description: String!
    
    //買われた時のみ生成
    var buyerId: String?
    
    init(price: Double, inStock: Int, itemName: String, sellerName: String, sellerImage: String, address: Address, images: [String], description: String) {
        
        self.price = price
        self.inStock = inStock
        self.itemName = itemName
        self.sellerName = sellerName
        self.sellerImage = sellerImage
        self.address = address
        self.images = images
        self.description = description
    }
    
}
