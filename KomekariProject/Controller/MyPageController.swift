//
//  MyPageController.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/09/21.
//

import UIKit

class MyPageController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    //MARK: - SetUp UI
    
    fileprivate func configureNavigationBar(){
        
        configureNavigationBar(Title: "マイページ", prefersLargeTitle: false, titleColor: UIColor.systemGreen)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(handleSignOut))
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
