//
//  User.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/08/29.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import UIKit

enum AccountType: Int {
    
    case seller
    case buyer
}

struct SellerInfo {
    
    var sellerName: String!
    var sellerImage: String!
    var address: Address!
}

struct User {
    
    var id: String
    var icon: String?
    var userName: String!
    var email: String!
    var createdAt: String!
    var accountType: AccountType!
    var address: Address?
    
    init(uid: String, dictionary: [String: Any]) {
        
        self.id = uid
        self.icon = dictionary["icon"] as? String
        self.userName = dictionary["userName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.accountType = dictionary["accountType"] as? AccountType ?? AccountType(rawValue: 0)
    }
    
    init(id: String,userName: String, icon: String?, email: String, createdAt: String, accountType: AccountType) {
        
        self.id = id
        self.icon = icon
        self.email = email
        self.userName = userName
        self.accountType = AccountType(rawValue: accountType.rawValue)
        self.createdAt = createdAt
    }
}
