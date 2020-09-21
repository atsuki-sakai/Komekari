//
//  ItemCollectionCell.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/09/21.
//

import UIKit

class ItemCollectionCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet{
            guard let image = image else { return }
            ItemImageView.image = image
        }
    }
    private let ItemImageView: UIImageView = {
        
        let iv = UIImageView()
        iv.backgroundColor = .clear
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(ItemImageView)
        ItemImageView.setDimension(height: 60, widht: 60)
        ItemImageView.centerY(inView: self)
        ItemImageView.centerX(inView: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ItemImageView.layer.cornerRadius = 8
        ItemImageView.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
