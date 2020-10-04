//
//  Constants.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/03.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

enum filePathType: String {
    
    case user = "UserImages"
    case Item = "ItemImages"
    case Address = "Address"
}

enum ImageSize: Int, CustomStringConvertible {

    case small
    case medium
    case large
    
    var description: String {
        
        switch self {
        case .small:
            return "_100x100.jpg"
        case .medium:
            return "_200x200.jpg"
        case .large:
            return "_400x400.jpg"
        }
    }
}


//MARK: - FireStore Reference

public let kItem_Reference = Firestore.firestore().collection(FirestoreRef.Item.rawValue)
public let kUser_Reference = Firestore.firestore().collection(FirestoreRef.User.rawValue)
public let kAddress_Reference = Firestore.firestore().collection(FirestoreRef.Address.rawValue)

//MARK: - Storage Reference

public let kStorage_Ref = "gs://komekariproject-e4352.appspot.com"

public let kItem_Images_Path = Storage.storage().reference(withPath: "ItemImages")
public let KUser_Images_Path = Storage.storage().reference(withPath: "UserImages")

//MARK: - User Model Constants

public let kUserLocalData = "UserLocalData"

public let kUserID = "UserID"
public let kIcon = "UserIcon"
public let kEmail = "UserEmail"
public let kUserName = "UserName"
public let kCreatedAt = "CreatedAt"
public let kAccountType = "AccountType"
public let kPurchasedItemIDs = "PurchasedItemIds"
public let kOnBoard = "OnBoard"

//MARK: - Item Model Constants

public let kItemID = "ItemID"
public let kSellerId = "SellerId"
public let kSellerName = "SellerName"
public let kSellerImage = "SellerImage"
public let kItemName = "ItemName"
public let kItemPrice = "Price"
public let kInStock = "InStock"
public let kItemImages = "ItemImages"
public let kItemDescription = "Description"
public let kSellerArea = "sellerArea"

//MARK: - Address Model Constants

public let kPrefecture = "都道府県"
public let kCity = "市町村"
public let kAddress = "番地"
public let kDetail = "その他、詳細情報"
