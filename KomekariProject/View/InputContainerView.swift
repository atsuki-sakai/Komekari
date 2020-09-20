//
//  InputContainerView.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/09/03.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import UIKit

class InputContainerView: UIView {
    
    var underLine: UIView!
    var tf: UITextField!
    
    init(image: UIImage, textField: UITextField) {
        self.tf = textField
        super.init(frame: .zero)
        
        setHeight(height: 50)
        
        let iv = UIImageView()
        iv.image = image
        iv.tintColor = .blue
        iv.alpha = 0.7
        
        addSubview(iv)
        iv.centerY(inView: self)
        iv.anchor(left: self.leftAnchor, padddingLeft: 8)
        iv.setDimension(height: 28, widht: 28)
        
        addSubview(textField)
        textField.centerY(inView: self)
        textField.anchor(left: iv.rightAnchor, right: rightAnchor, bottom: bottomAnchor, padddingLeft: 8, paddingBottom: -8)
        underLine = UIView()
        underLine.backgroundColor = .darkGray
        addSubview(underLine)
        underLine.anchor(left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, padddingLeft: 8, height: 2.5)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
