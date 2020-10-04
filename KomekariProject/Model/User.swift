//
//  User.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/08/29.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import UIKit

struct User {
    
    var id: String
    var icon: String
    var userName: String
    var email: String
    var createdAt: String
    var accountType: Int
    var purchasedItemIds: [String]
    var onBoard: Bool

    init(id: String,userName: String, icon: String, email: String, createdAt: String, accountType: Int) {
        
        self.id = id
        self.icon = icon
        self.email = email
        self.userName = userName
        self.accountType = accountType
        self.createdAt = createdAt
        self.purchasedItemIds = []
        self.onBoard = false
    }
    
    init(_dictionary: NSDictionary) {
        
        id = _dictionary[kUserID] as! String
        
        if let icon = _dictionary[kIcon] as? String {
            self.icon = icon
        }else{
            self.icon = ""
        }
        
        if let email = _dictionary[kEmail] as? String {
            self.email = email
        }else{
            self.email = ""
        }
        
        if let userName = _dictionary[kUserName] as? String {
            self.userName = userName
        }else{
            self.userName = ""
        }
        
        if let accountTypeRawValue = _dictionary[kAccountType] as? Int {
            self.accountType = accountTypeRawValue
        }else{
            self.accountType = 0
        }
        
        if let createdAt = _dictionary[kCreatedAt] as? String {
            self.createdAt = createdAt
        }else{
            self.createdAt = ""
        }
        
        if let purchasedIds = _dictionary[kPurchasedItemIDs] as? [String] {
            self.purchasedItemIds = purchasedIds
        }else{
            self.purchasedItemIds = []
        }
        
        if let onBoard = _dictionary[kOnBoard] as? Bool {
            self.onBoard = onBoard
        }else{
            self.onBoard = false
        }
        
    }
}

//MARK: - Helpers

func userDictionaryFrom(user: User) -> NSDictionary {
    
    return NSDictionary(objects: [user.id, user.icon, user.email, user.userName, user.accountType, user.createdAt, user.purchasedItemIds, user.onBoard], forKeys: [kUserID as NSCopying, kIcon as NSCopying, kEmail as NSCopying, kUserName as NSCopying, kAccountType as NSCopying, kCreatedAt as NSCopying, kPurchasedItemIDs as NSCopying, kOnBoard as NSCopying])
}

func getLocalUser() -> User? {

    if let dictionary = UserDefaults.standard.object(forKey: kUserLocalData) as? NSDictionary {
        return User(_dictionary: dictionary)
    }
    return nil
}

func saveUserLocalDataBase(userDictionary: NSDictionary) {
    UserDefaults.standard.setValue(userDictionary, forKey: kUserLocalData)
    print("Save UserDefaults With User")
}
