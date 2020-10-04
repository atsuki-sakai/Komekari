//
//  FavoriteTableCell.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/10/05.
//

import Foundation
import UIKit

class FavoriteTableCell: UITableViewCell {
    
    //MARK: - Properties
    
    private let itemNameLabel: UILabel = {
        
        let label = UILabel()
        
        return label
    }()
    
    //MARK: - ViewLifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(itemNameLabel)
        itemNameLabel.centerX(inView: self)
        itemNameLabel.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
}
