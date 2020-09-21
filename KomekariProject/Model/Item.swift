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
    var images: [String]!
    var description: String!
    var sellerInfo: SellerInfo?
    
    //買われた時のみ生成
    var buyerId: String?
    
    init(price: Double, inStock: Int, itemName: String, images: [String], description: String, sellerInfo: SellerInfo? = nil) {
        
        self.price = price
        self.inStock = inStock
        self.itemName = itemName
        self.images = images
        self.description = description
        self.sellerInfo = sellerInfo
    }
    
}
