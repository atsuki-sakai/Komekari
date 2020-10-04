//
//  FavoriteController.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/09/21.
//

import UIKit

private let reuseIdentifier = "FavoriteCell"

class FavoriteController: UITableViewController{
    
    //MARK: - Properties
    
    var user: User? {
        didSet{
            guard let user = user else { return }
            
            if user.accountType == 0 {
                //FIXME: 購入履歴を取得
            }else{
                //FIXME: 販売履歴を取得
            }
            configureUI()
        }
    }
    
    private var purchasedItems: [Item] = []
    private var sellingItems: [Item] = []
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(Title: "お気に入り", prefersLargeTitle: false)
    }
    
    //MARK: - SetUp UI
    
    fileprivate func configureUI() {
        
    }
    
    fileprivate func configureTableView() {
        
        tableView.register(FavoriteTableCell.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    //MARK: - Helpers
}

extension FavoriteController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user?.accountType == 0 ? purchasedItems.count: sellingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FavoriteTableCell
        
        return cell
    }
}
