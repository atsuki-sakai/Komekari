//
//  PurchaseHistory.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/12.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import Foundation

class PurchaseHistory {
    
    var buyerId: String
    var items: [Item]
    
    init(buyerId: String, items: [Item]) {
        
        self.buyerId = buyerId
        self.items = items
    }
}
