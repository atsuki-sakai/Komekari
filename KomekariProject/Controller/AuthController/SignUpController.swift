//
//  SignUpController.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/08/29.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import UIKit

protocol SignUpControllerDelegate: class {
    
    func sendUserCredential(email: String, pass: String)
}

class SignUpController: UIViewController {
    
    //MARK: - Properties

    weak var delegate: SignUpControllerDelegate?
    private var userImage: UIImage?
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "KOMEKARI"
        label.textColor = .white
        label.font = .systemFont(ofSize: 42)
        
        let iv = UIImageView(image: #imageLiteral(resourceName: "rice"))
        
        label.addSubview(iv)
        iv.contentMode = .scaleToFill
        iv.anchor(left: label.rightAnchor, padddingLeft: 8)
        iv.setDimension(height: 42, widht: 42)
        iv.centerY(inView: label)
        
        return label
    }()

    private let addImageButton: UIButton = {
        
        let iv = UIButton(type: .system)
        iv.setImage(#imageLiteral(resourceName: "camera").withRenderingMode(.alwaysOriginal), for: .normal)
        iv.contentMode = .scaleToFill
        iv.addTarget(self, action: #selector(handleAddImage), for: .touchUpInside)
        iv.clipsToBounds = true
        return iv
    }()
    private lazy var imageViewHeight: CGFloat = self.addImageButton.frame.height
    
    private let userNameInputView: InputContainerView = {
        
        let tf = CustomTextField(placeHolder: "UserName", type: .twitter)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        let image = UIImage(systemName: "person.fill")
        let view = InputContainerView(image: image!, textField: tf)
        return view
    }()
    
    private let emailInputView: InputContainerView = {
        
        let image = UIImage(systemName: "envelope.fill")
        let tf = CustomTextField(placeHolder: "Sample@emal.com", type: .emailAddress)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        let view = InputContainerView(image: image!, textField: tf)
        
        return view
    }()
    
    private lazy var passwordInputView: InputContainerView = {
        
        let image = UIImage(systemName: "lock.fill")
        let tf = CustomTextField(placeHolder: "Password", type: .emailAddress)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        let view = InputContainerView(image: image!, textField: tf)
        
        return view
    }()
    
    private let userTypeSegment: UISegmentedControl = {
        
        let items = ["購入する", "出品する"]
        let seg = UISegmentedControl(items: items)
        seg.selectedSegmentIndex = 0
        seg.selectedSegmentTintColor = .systemGreen
        seg.backgroundColor = .white
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)], for: .normal)
        return seg
    }()
    
    private let signUpButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setTitle("入力を完了してください", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 28)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 4
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    private let alreadyAccountButton: UIButton = {
        
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: "すでにアカウントをお持ちですか?  ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        attributeTitle.append(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]))
        button.setAttributedTitle(attributeTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    //MARK: - Selectors
    
    @objc func textDidChange(sender: UITextField) {
        
        UIView.animate(withDuration: 0.4) {
            self.changeStateOnInput(sender: sender)
        }
    }
    
    @objc func handleSignIn() {
        
      dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignUp() {
        
        signUpUser()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 90
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleAddImage() {
        
        showPhotoLibrary()
    }
    
    //MARK: - Helpers
    
    fileprivate func configureUI() {
        
        gradintBGColor(inView: view, topColor: .systemGreen, bottomColor: .white)
        configureTitleLabel()
        configureImageView()
        configureInputView()
        configureAlreadyButton()
        setUpNotification()
    }
    
    fileprivate func configureTitleLabel() {
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        titleLabel.centerX(inView: view, constant: -21)
    }
    
    fileprivate func configureImageView() {
        
        view.addSubview(addImageButton)
        addImageButton.anchor(top: titleLabel.bottomAnchor, paddingTop: 32, height: 130, width: 130)
        addImageButton.centerX(inView: view)
    }
    
    fileprivate func configureInputView() {
     
        let stack = UIStackView(arrangedSubviews: [userNameInputView, emailInputView, passwordInputView, userTypeSegment])
        view.addSubview(stack)
        
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.anchor(top: addImageButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 22, padddingLeft: 22, paddingRight: -22)
        stack.centerX(inView: view)
        
        view.addSubview(signUpButton)
        signUpButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, padddingLeft: 16, paddingRight: -16, height: 50)
        
    }
    
    fileprivate func configureAlreadyButton() {
        
        view.addSubview(alreadyAccountButton)
        alreadyAccountButton.anchor(bottom: view.bottomAnchor, paddingBottom: -22)
        alreadyAccountButton.centerX(inView: view)
    }
    
    fileprivate func changeStateOnInput(sender: UITextField) {
        
        changeSignInButtonState()
        
        switch sender {
        case emailInputView.tf:
            if sender.text!.count > 0 {
               self.emailInputView.underLine.backgroundColor = .systemBlue
            }else{
               self.emailInputView.underLine.backgroundColor = .darkGray
            }
        case passwordInputView.tf:
            if sender.text!.count > 6 {
                self.passwordInputView.underLine.backgroundColor = .systemBlue
            }else{
               self.passwordInputView.underLine.backgroundColor = .darkGray
            }
        case userNameInputView.tf:
            if sender.text!.count > 0 {
                self.userNameInputView.underLine.backgroundColor = .systemBlue
            }else{
                self.userNameInputView.underLine.backgroundColor = .darkGray
            }
        default:
            return
        }
    }
    
    fileprivate func changeSignInButtonState() {
      
        if emailInputView.tf.text!.count > 6 && passwordInputView.tf.text!.count > 6 && !userNameInputView.tf.text!.isEmpty {
            signUpButton.backgroundColor = .systemGreen
            signUpButton.isEnabled = true
            signUpButton.setTitle("登録", for: .normal)
        }else{
            signUpButton.backgroundColor = .lightGray
            signUpButton.isEnabled = false
            signUpButton.setTitle("入力を完了してください", for: .normal)
        }
    }
    
    fileprivate func setUpNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func signUpUser(){
        
        checkHasConnection()
        changeButtonState(enable: false)
        guard let email = emailInputView.tf.text else { return }
        guard let pass = passwordInputView.tf.text else { return }
        guard let name = userNameInputView.tf.text else { return }
        
        AuthService.shared.signUp(email: email, pass: pass) { (error) in
            if let error = error {
                self.errorAlert(message: error.localizedDescription)
                self.changeButtonState(enable: true)
            }
            
            if self.userImage == nil {
                self.userImage = UIImage(systemName: "person")
            }
            guard let uid = AuthService.currentnUid() else { return }
            ImageLoader.uploadImages(pathType: .user, images: [self.userImage], uid: uid) { [self] (error, imageLinks) in
                
                if let error = error {
                    self.errorAlert(message: error.localizedDescription)
                    self.changeButtonState(enable: true)
                    return
                }
                print("links",imageLinks)
                guard let url = imageLinks.first else { return }
                let user = User(id: uid, userName: name, icon: url, email: email, createdAt: getCurrentTime(), accountType: userTypeSegment.selectedSegmentIndex)
                print("user",user)
                AuthService.shared.saveUser(user: user) { (error) in
                    
                    if let error = error {
                        self.errorAlert(message: error.localizedDescription)
                        self.changeButtonState(enable: true)
                        return
                    }
                    self.changeButtonState(enable: true)
                    self.messageAlert(title: "登録完了", message: "送られてきたメールを書くんインしてください。") { (_) in
                        
                        self.delegate?.sendUserCredential(email: email, pass: pass)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
         
        }
    }
    
    fileprivate func changeButtonState(enable: Bool) {
        
        if enable {
            self.signUpButton.isEnabled = true
            self.showloader(false)
        }else{
            self.signUpButton.isEnabled = false
            self.showloader(true)
        }
        
    }

}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showPhotoLibrary() {
        
        let sourceType: UIImagePickerController.SourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = sourceType
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        userImage = image
        addImageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        addImageButton.layer.cornerRadius = 120/2
        addImageButton.layer.borderColor = UIColor.black.cgColor
        addImageButton.layer.borderWidth = 0.4
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
