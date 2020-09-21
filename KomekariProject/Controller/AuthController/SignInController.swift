//
//  SignUpController.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/08/29.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import UIKit

class SignInController: UIViewController {
    
    //MARK: - Properties
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
    
    private let imageView: UIImageView = {
        
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "diner").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleToFill
        
        return iv
    }()
    
    private let emailInputView: InputContainerView = {
        
        let image = UIImage(systemName: "envelope.fill")
        let tf = CustomTextField(placeHolder: "sample@emal.com", type: .emailAddress)
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        let view = InputContainerView(image: image!, textField: tf)
        
        return view
    }()
    
    private let passwordInputView: InputContainerView = {
        
        let image = UIImage(systemName: "lock.fill")
        let tf = CustomTextField(placeHolder: "password", type: .emailAddress)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        let view = InputContainerView(image: image!, textField: tf)
        
        return view
    }()
    
    private let signInButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setTitle("入力を完了してください", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 28)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 4
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        
        return button
    }()
    
    private let handleSignUpButton: UIButton = {
        
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: "まだアカウントをお持ちでないですか?  ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        attributeTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]))
        button.setAttributedTitle(attributeTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let resentEmailButton: UIButton = {
        
        let button = UIButton(type: .system)
        let atributeString = NSMutableAttributedString(string: "メールが届きませんか？", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        atributeString.append(NSAttributedString(string: " 再送信する", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]))
        button.setAttributedTitle(atributeString, for: .normal)
        button.addTarget(self, action: #selector(handleResendEmail), for: .touchUpInside)
        return button
    }()
    
    private let resetPasswordButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(string: "パスワードをお忘れですか？", attributes: [.foregroundColor: UIColor.systemRed, .font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal)
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        button.alpha = 0
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
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
    
    @objc func textFieldDidChange(sender: UITextField) {
        
        UIView.animate(withDuration: 0.4) {
            self.changeUnderLineColor(sender: sender)
            self.changeColorSignInButton()
        }
    }
    
    @objc func handleSignUp() {
        
        let controller = SignUpController()
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    @objc func handleSignIn() {
        
        self.showloader(true)
        self.signInButton.isEnabled = false
        if !Reachabilty.HasConnection() {
            self.messageAlert(title: "通信エラー", message: "通信状況を確認してください。", completion: nil)
            self.signInButton.isEnabled = true
            self.showloader(false)
        }
        let credential = AuthCredential(email: emailInputView.tf.text!, password: passwordInputView.tf.text!)
        AuthService.shared.login(credential: credential) { (error) in
            
            if let error = error {
                self.signInButton.isEnabled = true
                self.showloader(false)
                self.errorAlert(message: error.localizedDescription)
            }
            self.resetPasswordButton.removeFromSuperview()
            self.signInButton.isEnabled = true
            self.showloader(false)
            guard let controller = mainNavigationController?.viewControllers.first as? MainController else { return }
            controller.checkFormStates()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 50
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleResetPassword() {
        guard let email = emailInputView.tf.text else { return }
        AuthService.shared.resetPassword(email: email) { (error) in
            
            if let error = error {
                self.messageAlert(title: "リセットパスワード　エラー", message: error.localizedDescription, completion: nil)
                return
            }
        }
        self.messageAlert(title: "メールを送信しました。", message: "送られてきたメールからパスワードを再設定してください。") { (_) in
            self.passwordInputView.tf.text = ""
        }
    }
    
    @objc func handleResendEmail() {
       
        guard let email = emailInputView.tf.text else { return }
        
        AuthService.shared.resendValificationEmail(email: email) { (error) in
            
            if let error = error {
                self.messageAlert(title: "メールの送信に失敗", message: error.localizedDescription, completion: nil)
                return
            }
            self.messageAlert(title: "メールを送信しました。", message:  "送られてきたメールを確認してください。") { (_) in
                self.emailInputView.tf.text = ""
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        gradintBGColor(inView: view, topColor: UIColor.systemTeal, bottomColor: UIColor.white)
        configureTitleLabel()
        configureImageView()
        configureInputView()
        configureAlreadyButton()
        setUpNotification()
    }
    
    fileprivate func setUpresentEmailButton() {
        
        view.addSubview(resentEmailButton)
        resentEmailButton.anchor(top: resetPasswordButton.bottomAnchor, paddingTop: 16)
        resentEmailButton.centerX(inView: self.view)
    }
    
    fileprivate func configureTitleLabel() {
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        titleLabel.centerX(inView: view, constant: -21)
    }
    
    fileprivate func configureImageView() {
        
        view.addSubview(imageView)
        imageView.anchor(top: titleLabel.bottomAnchor, paddingTop: 32, height: 120, width: 120)
        imageView.centerX(inView: view)
    }
    
    fileprivate func configureInputView() {
     
        let stack = UIStackView(arrangedSubviews: [emailInputView, passwordInputView])
        view.addSubview(stack)
        
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 22, padddingLeft: 22, paddingRight: -22)
        stack.centerX(inView: view)
        
        view.addSubview(signInButton)
        signInButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, padddingLeft: 16, paddingRight: -16, height: 50)
        
        view.addSubview(resetPasswordButton)
        resetPasswordButton.anchor(top: signInButton.bottomAnchor, paddingTop: 32)
        resetPasswordButton.centerX(inView: view)
    }
    
    fileprivate func configureAlreadyButton() {
        
        view.addSubview(handleSignUpButton)
        handleSignUpButton.anchor(bottom: view.bottomAnchor, paddingBottom: -22)
        handleSignUpButton.centerX(inView: view)
    }
    
    fileprivate func changeUnderLineColor(sender: UITextField) {
        
        if sender == emailInputView.tf {
                   
            if sender.text!.count > 6 {
                self.emailInputView.underLine.backgroundColor = .systemBlue
                self.resetPasswordButton.alpha = 1
            }else{
                self.emailInputView.underLine.backgroundColor = .darkGray
                self.resetPasswordButton.alpha = 0
            }
        }else if sender == passwordInputView.tf {
            if sender.text!.count > 6 {
                self.passwordInputView.underLine.backgroundColor = .systemBlue
            }else{
               self.passwordInputView.underLine.backgroundColor = .darkGray
            }
        }
    }
    
    fileprivate func changeColorSignInButton() {
        
        if emailInputView.tf.text!.count > 0 && passwordInputView.tf.text!.count > 6 {
            
            signInButton.backgroundColor = .systemGreen
            signInButton.isEnabled = true
            signInButton.setTitle("ログイン", for: .normal)
        }else{
            signInButton.backgroundColor = .lightGray
            signInButton.isEnabled = false
            signInButton.setTitle("入力を完了してください", for: .normal)
        }
    }
    
    fileprivate func setUpNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
}

extension SignInController: SignUpControllerDelegate {
    
    func sendUserCredential(credential: AuthCredential) {
        
        emailInputView.tf.text = credential.email
        passwordInputView.tf.text = credential.password
        emailInputView.underLine.backgroundColor = .systemBlue
        passwordInputView.underLine.backgroundColor = .systemBlue
        signInButton.backgroundColor = .systemGreen
        signInButton.isEnabled = true
        setUpresentEmailButton()
    }
}

