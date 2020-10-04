//
//  FirebaseCollectionReference.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

enum FirestoreRef: String {
    
    case User
    case Item
    case Address
    case Cart
    case PurchaseHistory
    case SellerInfo
}
enum StorageRef: String {
    
    case ItemImages
    case UserImages
}

func FirebaseCollectionRef(_ FirestoreRef: FirestoreRef) -> CollectionReference {
    return Firestore.firestore().collection(FirestoreRef.rawValue)
}

func FirebaseStorageRef(_ StorageRef: StorageRef) -> StorageReference {
    return Storage.storage().reference(withPath: StorageRef.rawValue)
}
