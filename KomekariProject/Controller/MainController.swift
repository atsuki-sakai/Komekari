//
//  MainController.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/09/21.
//

import UIKit
import FirebaseAuth

class MainController: UIViewController {

    //MARK: - Properties
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFormStates()
    }
    
    //MARK: - SetUp UI
    
    //MARK: - Helpers
    
    fileprivate func configureUI() {
        
    }
    
    func checkFormStates() {
        
        if Auth.auth().currentUser?.uid != nil && Auth.auth().currentUser?.isEmailVerified == true{
            configureUI()
        }else{
            DispatchQueue.main.async {
                let controller = SignInController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
}
