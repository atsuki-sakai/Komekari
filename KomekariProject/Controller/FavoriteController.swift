//
//  FavoriteController.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/09/21.
//

import UIKit

class FavoriteController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(Title: "お気に入り", prefersLargeTitle: false)
    }
    
    //MARK: - SetUp UI
    
    //MARK: - Helpers
}
