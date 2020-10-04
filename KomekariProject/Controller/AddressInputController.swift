//
//  AddressInputController.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/09/25.
//

import UIKit

class AddressInputController: UIViewController {
    
    //MARK: - Properties
    
    var user: User? = getLocalUser()
  
    private lazy var prefectureInputView: InputContainerView = {
        
        let image = UIImage(systemName: "person")
        let tf = CustomTextField(placeHolder: "都道府県", type: .namePhonePad)
        tf.inputAccessoryView = toolBar
        tf.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        let view = InputContainerView(image: image!, textField: tf)
        
        return view
    }()
    private lazy var cityInputView: InputContainerView = {
        
        let image = UIImage(systemName: "person")
        let tf = CustomTextField(placeHolder: "市", type: .namePhonePad)
        tf.inputAccessoryView = toolBar
        tf.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        let view = InputContainerView(image: image!, textField: tf)
        return view
    }()
    private lazy var addressInputView: InputContainerView = {
        
        let image = UIImage(systemName: "person")
        let tf = CustomTextField(placeHolder: "区、町、村", type: .namePhonePad)
        tf.inputAccessoryView = toolBar
        tf.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        let view = InputContainerView(image: image!, textField: tf)
        return view
    }()
    private lazy var detailInputView: InputContainerView = {
        
        let image = UIImage(systemName: "person")
        let tf = CustomTextField(placeHolder: "番地、マンション", type: .namePhonePad)
        tf.inputAccessoryView = toolBar
        tf.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        let view = InputContainerView(image: image!, textField: tf)
        return view
    }()
    
    private let addAddressButton: UIButton = {
        
        let button = UIButton(type: .system)
        let titleString = NSMutableAttributedString(string: "入力してください", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        button.setAttributedTitle(titleString, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 4
        button.clipsToBounds = false
        button.addTarget(self, action: #selector(saveAddress), for: .touchUpInside)
        
        return button
    }()
    
    private let toolBar: UIToolbar = {
        
        let toolBar = UIToolbar()
        let flexible = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let dismissKeyBoardButton = UIBarButtonItem(title: "終了", style: .done, target: self, action: #selector(handleDismissKeyBoard))
        dismissKeyBoardButton.tintColor = .red
        toolBar.items = [flexible, dismissKeyBoardButton]
        toolBar.sizeToFit()
        return toolBar
    }()
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        setUpNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    //MARK: - Selectors
    
    @objc func handleDismissKeyBoard() {
        
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 80
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += 80
        }
    }
    
    @objc func textDidChange(_ sender: UITextField) {
        
        UIView.animate(withDuration: 0.2) {
            if self.checkInputField() {
                self.addAddressButton.setTitle("登録", for: .normal)
                self.addAddressButton.isEnabled = true
                self.addAddressButton.backgroundColor = .systemGreen
            }else{
                self.addAddressButton.setTitle("入力してください", for: .normal)
                self.addAddressButton.isEnabled = false
                self.addAddressButton.backgroundColor = .lightGray
            }
        }
    }
    
    @objc func saveAddress() {
        
        guard var user = self.user else { return }
        self.showloader(true)
        let address = Address(userId: user.id, prefecture: prefectureInputView.tf.text!, city: cityInputView.tf.text!, address: addressInputView.tf.text!, detail: detailInputView.tf.text!)
        
        FireAPI.saveToAddress(userId: user.id, address: address) { (error) in
            
            if let error = error {
                self.errorAlert(message: error.localizedDescription)
                self.showloader(false)
                return
            }
            user.onBoard = true
            saveUserLocalDataBase(userDictionary: userDictionaryFrom(user: user))
            AuthService.shared.saveUser(user: user) { (error) in
                if let error = error {
                    self.errorAlert(message: error.localizedDescription)
                    self.showloader(false)
                    return
                }
                self.showloader(false)
                self.dismiss(animated: true, completion: nil)
                print("completed")
            }
        }
    }
    
    //MARK: - Helpers
    
    fileprivate func configureUI() {
        
        let stack = UIStackView(arrangedSubviews: [prefectureInputView, cityInputView, addressInputView, detailInputView])
        stack.axis = .vertical
        stack.spacing = 32
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 80, padddingLeft: 16, paddingRight: -16)
        stack.centerX(inView: self.view)
        view.addSubview(addAddressButton)
        addAddressButton.anchor(top: stack.bottomAnchor,left: stack.leftAnchor, right: stack.rightAnchor, paddingTop: 64, height: 64)
        addAddressButton.centerX(inView: self.view)
    }
    
    fileprivate func checkInputField() -> Bool {
        return prefectureInputView.tf.text != "" && cityInputView.tf.text != "" && addressInputView.tf.text != "" && detailInputView.tf.text != ""
    }
    
    fileprivate func configureNavigationBar() {
        configureNavigationBar(Title: "受け取り住所を入力", prefersLargeTitle: false)
    }
    
    fileprivate func setUpNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
