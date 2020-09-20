//
//  Cart.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/12.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import Foundation

class Cart {
    
    var userId: String!
    var inItems: [Item]?
    
    init(userId: String, inItems: [Item]) {
        
        self.userId = userId
        self.inItems = inItems
    }
}
