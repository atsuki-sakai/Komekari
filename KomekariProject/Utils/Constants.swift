//
//  Constants.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/03.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import FirebaseDatabase
import FirebaseStorage

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

//MARK: - Database Reference

public let KUSER_DB_REF = Database.database().reference(withPath: "Users")

//MARK: - Storage
public let KSTORAGE_THUMBNAILS = Storage.storage().reference(withPath: "UserIcons").child("thumbnails")
public let KSTORAGE_ICONS = Storage.storage().reference(withPath: "UserIcons")


