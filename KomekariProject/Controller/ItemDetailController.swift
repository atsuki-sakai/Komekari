//
//  ItemDetailController.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/10/03.
//

import UIKit

class ItemDetailController: UIViewController {
    
    //MARK: - Properties
    var item: Item {
        didSet {
            print(item.itemName)
        }
    }
    
    //MARK: - View LifeCycle
    
    init(item: Item, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.item = item
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    //MARK: - Helpers
    
    
}
