//
//  MyPageController.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/09/21.
//

import UIKit

class MyPageController: UIViewController {
    
    //MARK: - Properties
    
    var user: User? {
        didSet{
            guard let user = user else { return }
            print("MyPage User =>", user)
            
        }
    }
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(Title: "マイページ", prefersLargeTitle: false)
    }
    
    //MARK: - SetUp UI
    
    fileprivate func configureNavigationBar(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(handleSignOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(handleAddItemController))
    }
    
    //MARK: - Selectors
    
    @objc func handleAddItemController() {
        
        let controller = UINavigationController(rootViewController: AddItemController())
        present(controller, animated: true, completion: nil)
    }
    
    @objc func handleSignOut() {
        
        AuthService.shared.signOut { (error) in
            
            if let error = error {
                self.errorAlert(message: error.localizedDescription)
                return
            }
            let alert = UIAlertController(title: "ログアウトしますか？", message: nil, preferredStyle: .actionSheet)
            let ok = UIAlertAction(title: "ログアウト", style: .default) { (_) in
                let controller = SignInController()
                controller.configureUI()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Helpers
}
