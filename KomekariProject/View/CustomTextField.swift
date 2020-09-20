//
//  CustomTextField.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/03.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import UIKit

class CustomTextField: UITextField{
    
    init(placeHolder: String, type: UIKeyboardType){
        super.init(frame: .zero)
        
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = .black
        keyboardAppearance = .dark
        keyboardType = type
        attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [.foregroundColor: UIColor.lightGray])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
