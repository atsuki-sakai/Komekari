//
//  CustomError.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/03.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import UIKit

enum CustomError: Error {
    
    case logOut
    case emailValid
}

extension CustomError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .logOut:
            return "ログアウト時にエラーが発生しました。"
        case .emailValid:
            return "メールを確認し、認証を完了してください。"
        }
    }
}
