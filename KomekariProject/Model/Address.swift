//
//  Address.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/12.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import Foundation

struct Address {
    
    var userId: String
    var prefecture: String
    var city: String
    var address: String
    var detailInfo: String
    
    init(userId: String, prefecture: String, city: String, address: String, detail: String) {
        self.userId = userId
        self.prefecture = prefecture
        self.city = city
        self.address = address
        self.detailInfo = detail
    }
    
    init(dictionary: NSDictionary) {
        
        if let userId = dictionary[kUserID] as? String {
            self.userId = userId
        }else{
            self.userId = ""
        }
        if let prefecture = dictionary[kPrefecture] as? String {
            self.prefecture = prefecture
        }else{
            self.prefecture = ""
        }
        if let city = dictionary[kCity] as? String {
            self.city = city
        }else{
            self.city = ""
        }
        if let address = dictionary[kAddress] as? String {
            self.address = address
        }else{
            self.address = ""
        }
        if let detail = dictionary[kDetail] as? String {
            self.detailInfo = detail
        }else{
            self.detailInfo = ""
        }
    }
}

func addressFromDictionary(address: Address) -> NSDictionary {
    return NSDictionary(objects: [address.userId ,address.prefecture, address.city, address.address, address.detailInfo], forKeys: [kUserID as NSCopying,kPrefecture as NSCopying, kCity as NSCopying, kAddress as NSCopying, kDetail as NSCopying])
}

