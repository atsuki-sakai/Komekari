//
//  MainTableCell.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/10/02.
//

import UIKit
import SDWebImage

class MainTableCell: UITableViewCell {
    
    //MARK: - Properties
    private let itemNameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    private let sellerNameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let priceLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    private let itemImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    private let sellerImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        return imageView
    }()
    private let descriptionLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 10
        label.textColor = .white
        return label
    }()
    
    private let sellerAreaLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    var item: Item? {
        didSet{
            
            guard let item = self.item else { return }
            itemNameLabel.text = item.itemName
            priceLabel.text = "¥ " + String(Int(item.price))
            descriptionLabel.text = item.description
            itemImageView.sd_setImage(with: URL(string: item.images.first!), completed: nil)
            sellerAreaLabel.text = "\(String(Prefectures.init(rawValue: item.sellerArea)!.description)) 産"
            sellerNameLabel.text = item.sellerName
            sellerImageView.sd_setImage(with: URL(string: item.sellerImage), completed: nil)
        }
    }
    //MARK: - ViewLifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(itemImageView)
        itemImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, padddingLeft: 8, paddingRight: -8, height: 260)
        self.addSubview(sellerAreaLabel)
        
        let bluerView = UIView()
        bluerView.backgroundColor = .darkGray
        bluerView.alpha = 0.85
        bluerView.layer.cornerRadius = 8
        bluerView.clipsToBounds = true
        bluerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.addSubview(bluerView)
        bluerView.anchor(left: leftAnchor, right: rightAnchor, bottom: bottomAnchor
                         , padddingLeft: 8, paddingRight: -8, paddingBottom: -4, height: 140)
        
        addSubview(sellerImageView)
        let sellerImageViewHeight: CGFloat = 100
        sellerImageView.anchor(top: bluerView.topAnchor, left: leftAnchor, paddingTop: -42, padddingLeft: 18, height: sellerImageViewHeight, width: sellerImageViewHeight)
        sellerImageView.layer.cornerRadius = sellerImageViewHeight/2
        
        self.addSubview(sellerNameLabel)
        sellerNameLabel.centerY(inView: sellerImageView, constant: 10)
        sellerNameLabel.anchor(left: sellerImageView.rightAnchor,right: self.rightAnchor, padddingLeft: 16)
        
        
        let VStack = UIStackView(arrangedSubviews: [priceLabel, sellerAreaLabel])
        VStack.axis = .vertical
        VStack.spacing = 16
        VStack.distribution = .fillEqually

        self.addSubview(VStack)
        VStack.anchor(top: sellerImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 8, padddingLeft: 22, paddingBottom: -16, width: 80)
        
        self.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: sellerNameLabel.bottomAnchor, left: sellerImageView.rightAnchor, right: rightAnchor, bottom: bottomAnchor,paddingTop: 8, paddingRight: -16, paddingBottom: -8)
        
        self.addSubview(itemNameLabel)
        itemNameLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, padddingLeft: 16, paddingRight: -16, height: 64, width: self.frame.width)
        itemNameLabel.centerX(inView: self)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
}

extension MainTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
}
