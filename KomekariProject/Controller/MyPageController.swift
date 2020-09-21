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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(handleSignOut))
        
        if user?.accountType.rawValue == 1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(handleSignOut))
        }
        
    }
    
    //MARK: - Selectors
    
    @objc func handleSignOut() {
        
        AuthService.shared.signOut { (error) in
            
            if let error = error {
                self.errorAlert(message: error.localizedDescription)
                return
            }
            let controller = SignInController()
            controller.configureUI()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //MARK: - Helpers
}
